const express = require('express');
const { body, param, validationResult } = require('express-validator');
const { exec } = require('child_process');
const fs = require('fs').promises;
const path = require('path');
const url = require('url');
const auth = require('../middleware/auth');

const router = express.Router();

// Middleware de autenticación y permisos de admin
router.use(auth.authenticateToken);
router.use(auth.requirePermission('admin'));

// Función helper para parsear DATABASE_URL
const parseDatabaseUrl = (databaseUrl) => {
  const parsedUrl = url.parse(databaseUrl);
  return {
    host: parsedUrl.hostname,
    port: parsedUrl.port,
    database: parsedUrl.pathname.substring(1),
    username: parsedUrl.auth.split(':')[0],
    password: parsedUrl.auth.split(':')[1]
  };
};

// POST /api/system/backup - Crear backup de la base de datos
router.post('/backup', async (req, res) => {
  try {
    const dbConfig = parseDatabaseUrl(process.env.DATABASE_URL);
    const timestamp = new Date().toISOString().replace(/[:.]/g, '').replace('T', '_').split('.')[0];
    const backupFileName = `dtic_bitacoras_backup_${timestamp}.sql`;
    const backupPath = path.join('/host', '_app-bitacoras', 'backups', backupFileName);

    // Usar Docker para ejecutar pg_dump en el contenedor de PostgreSQL
    const tempBackupName = `temp_backup_${Date.now()}.sql`;
    const dockerPgDumpCommand = `docker exec -e PGPASSWORD=${dbConfig.password} dtic_bitacoras_postgres pg_dump -h localhost -p 5432 -U ${dbConfig.username} -d ${dbConfig.database} -f /tmp/${tempBackupName}`;

    // Ejecutar pg_dump dentro del contenedor PostgreSQL
    await new Promise((resolve, reject) => {
      const child = exec(dockerPgDumpCommand, (error, stdout, stderr) => {
        if (error) {
          console.error('Error en pg_dump dentro del contenedor:', error);
          console.error('Stderr:', stderr);
          reject(new Error(`Error creando backup: ${error.message}`));
          return;
        }
        console.log('Backup creado exitosamente en contenedor:', backupFileName);
        resolve();
      });
    });

    // Copiar el backup desde el contenedor al host
    const dockerCpCommand = `docker cp dtic_bitacoras_postgres:/tmp/${tempBackupName} ${backupPath}`;
    await new Promise((resolve, reject) => {
      const child = exec(dockerCpCommand, (error, stdout, stderr) => {
        if (error) {
          console.error('Error copiando backup desde contenedor:', error);
          console.error('Stderr:', stderr);
          reject(new Error(`Error copiando backup: ${error.message}`));
          return;
        }
        console.log('Backup copiado exitosamente al host:', backupPath);
        resolve();
      });
    });

    // Limpiar archivo temporal del contenedor
    const dockerRmCommand = `docker exec dtic_bitacoras_postgres rm -f /tmp/${tempBackupName}`;
    await new Promise((resolve, reject) => {
      const child = exec(dockerRmCommand, (error, stdout, stderr) => {
        if (error) {
          console.warn('Advertencia: No se pudo limpiar archivo temporal del contenedor:', error.message);
          // No rechazamos aquí, ya que el backup ya se copió exitosamente
        }
        resolve();
      });
    });

    res.json({
      success: true,
      message: 'Backup creado exitosamente',
      data: {
        backup_file: backupFileName,
        backup_path: backupPath,
        created_at: new Date().toISOString()
      }
    });

  } catch (error) {
    console.error('Error creando backup:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al crear backup'
    });
  }
});

// POST /api/system/restore - Restaurar base de datos desde backup
router.post('/restore', [
  body('backup_file').isString().notEmpty().withMessage('Nombre del archivo de backup es requerido')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Datos inválidos',
        errors: errors.array()
      });
    }

    const { backup_file } = req.body;
    const dbConfig = parseDatabaseUrl(process.env.DATABASE_URL);
    const backupPath = path.join('/host', '_app-bitacoras', 'backups', backup_file);

    // Verificar que el archivo existe
    try {
      await fs.access(backupPath);
    } catch (error) {
      return res.status(404).json({
        success: false,
        message: 'Archivo de backup no encontrado'
      });
    }

    // Comando pg_restore
    const pgRestoreCommand = `pg_restore --host=${dbConfig.host} --port=${dbConfig.port} --username=${dbConfig.username} --dbname=${dbConfig.database} --no-password --clean --if-exists --create ${backupPath}`;

    // Ejecutar pg_restore
    await new Promise((resolve, reject) => {
      const child = exec(pgRestoreCommand, {
        env: { ...process.env, PGPASSWORD: dbConfig.password }
      }, (error, stdout, stderr) => {
        if (error) {
          console.error('Error en pg_restore:', error);
          console.error('Stderr:', stderr);
          reject(new Error(`Error restaurando backup: ${error.message}`));
          return;
        }
        console.log('Backup restaurado exitosamente:', backup_file);
        resolve();
      });
    });

    res.json({
      success: true,
      message: 'Base de datos restaurada exitosamente',
      data: {
        backup_file: backup_file,
        restored_at: new Date().toISOString()
      }
    });

  } catch (error) {
    console.error('Error restaurando backup:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al restaurar backup'
    });
  }
});

// GET /api/system/backups - Listar archivos de backup disponibles
router.get('/backups', async (req, res) => {
  console.log('GET /backups - Starting list backups request');
  try {
    const backupsDir = path.join('/host', '_app-bitacoras', 'backups');
    console.log('GET /backups - Backups dir:', backupsDir);

    // Leer directorio de backups
    const files = await fs.readdir(backupsDir);
    console.log('GET /backups - Files in dir:', files);

    // Filtrar archivos .sql y obtener información
    const backupFiles = await Promise.all(
      files
        .filter(file => file.endsWith('.sql'))
        .map(async (file) => {
          const filePath = path.join(backupsDir, file);
          const stats = await fs.stat(filePath);

          // Extraer timestamp del nombre del archivo
          const timestampMatch = file.match(/dtic_bitacoras_backup_(\d{4}-?\d{2}-?\d{2})_(\d{6,9})(Z?)\.sql/);
          let createdAt = null;
          if (timestampMatch) {
            const dateStr = timestampMatch[1];
            const timeStr = timestampMatch[2];
            const z = timestampMatch[3];
            let year, month, day;
            if (dateStr.includes('-')) {
              [year, month, day] = dateStr.split('-');
            } else {
              year = dateStr.substring(0, 4);
              month = dateStr.substring(4, 6);
              day = dateStr.substring(6, 8);
            }
            let hour, minute, second, ms = '000';
            if (timeStr.length === 6) {
              hour = timeStr.substring(0, 2);
              minute = timeStr.substring(2, 4);
              second = timeStr.substring(4, 6);
            } else if (timeStr.length === 9) {
              hour = timeStr.substring(0, 2);
              minute = timeStr.substring(2, 4);
              second = timeStr.substring(4, 6);
              ms = timeStr.substring(6, 9);
            }
            createdAt = `${year}-${month}-${day}T${hour}:${minute}:${second}.${ms}Z`;
          }

          return {
            filename: file,
            size: stats.size,
            created_at: createdAt || stats.birthtime.toISOString(),
            modified_at: stats.mtime.toISOString()
          };
        })
    );

    // Ordenar por fecha de creación descendente
    backupFiles.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));

    res.json({
      success: true,
      message: 'Archivos de backup obtenidos exitosamente',
      data: {
        backups: backupFiles,
        total: backupFiles.length
      }
    });

  } catch (error) {
    console.error('Error listando backups:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al listar backups'
    });
  }
});

// DELETE /api/system/backups/:filename - Eliminar archivo de backup
router.delete('/backups/:filename', [
  param('filename').isString().matches(/^dtic_bitacoras_backup_(?:\d{4}-\d{2}-\d{2}|\d{8})_\d{6,9}Z?\.sql$/).withMessage('Nombre de archivo de backup inválido')
], async (req, res) => {
  console.log('DELETE /backups/:filename - Starting deletion request');
  console.log('Filename param:', req.params.filename);
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      console.log('DELETE /backups/:filename - Validation errors:', errors.array());
      return res.status(400).json({
        success: false,
        message: 'Datos inválidos',
        errors: errors.array()
      });
    }

    const { filename } = req.params;
    const backupsDir = path.join('/host', '_app-bitacoras', 'backups');
    const filePath = path.join(backupsDir, filename);
    console.log('DELETE /backups/:filename - Backups dir:', backupsDir);
    console.log('DELETE /backups/:filename - File path:', filePath);

    // Verificar que el archivo existe
    try {
      await fs.access(filePath);
      console.log('DELETE /backups/:filename - File exists');
    } catch (error) {
      console.log('DELETE /backups/:filename - File does not exist, error:', error.message);
      return res.status(404).json({
        success: false,
        message: 'Archivo de backup no encontrado'
      });
    }

    // Eliminar el archivo
    await fs.unlink(filePath);
    console.log('DELETE /backups/:filename - File deleted successfully');

    res.json({
      success: true,
      message: 'Archivo de backup eliminado exitosamente',
      data: {
        filename: filename,
        deleted_at: new Date().toISOString()
      }
    });

  } catch (error) {
    console.error('Error eliminando backup:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al eliminar backup'
    });
  }
});

// GET /api/system/backups/:filename/download - Descargar archivo de backup
router.get('/backups/:filename/download', [
  param('filename').isString().matches(/^dtic_bitacoras_backup_(?:\d{4}-\d{2}-\d{2}|\d{8})_\d{6,9}Z?\.sql$/).withMessage('Nombre de archivo de backup inválido')
], async (req, res) => {
  console.log('GET /backups/:filename/download - Starting download request');
  console.log('Filename param:', req.params.filename);
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      console.log('GET /backups/:filename/download - Validation errors:', errors.array());
      return res.status(400).json({
        success: false,
        message: 'Datos inválidos',
        errors: errors.array()
      });
    }

    const { filename } = req.params;
    const backupsDir = path.join('/host', '_app-bitacoras', 'backups');
    const filePath = path.join(backupsDir, filename);
    console.log('GET /backups/:filename/download - Backups dir:', backupsDir);
    console.log('GET /backups/:filename/download - File path:', filePath);

    // Verificar que el archivo existe
    try {
      await fs.access(filePath);
      console.log('GET /backups/:filename/download - File exists');
    } catch (error) {
      console.log('GET /backups/:filename/download - File does not exist, error:', error.message);
      return res.status(404).json({
        success: false,
        message: 'Archivo de backup no encontrado'
      });
    }

    // Enviar el archivo como descarga
    console.log('GET /backups/:filename/download - Starting file download');
    res.download(filePath, filename, (error) => {
      if (error) {
        console.error('Error descargando backup:', error);
        // Si la respuesta ya fue enviada, no hacer nada
        if (!res.headersSent) {
          res.status(500).json({
            success: false,
            message: 'Error interno del servidor al descargar backup'
          });
        }
      } else {
        console.log('GET /backups/:filename/download - File download completed successfully');
      }
    });

  } catch (error) {
    console.error('Error procesando descarga de backup:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al procesar descarga'
    });
  }
});

module.exports = router;