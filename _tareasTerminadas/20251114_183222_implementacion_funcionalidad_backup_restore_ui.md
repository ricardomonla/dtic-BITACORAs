# Implementación de Funcionalidad de Backup y Restore - UI

## Resumen

Esta implementación proporciona una interfaz de usuario completa para la gestión de backups de la base de datos del sistema DTIC Bitácoras. Incluye funcionalidades para crear backups, restaurar desde backups existentes y visualizar el historial de backups disponibles.

## Arquitectura

### Backend (API)

#### Endpoints Implementados

1. **POST /api/system/backup**
   - Crea un backup completo de la base de datos PostgreSQL
   - Utiliza pg_dump dentro del contenedor Docker
   - Almacena el backup en el directorio `/host/_app-bitacoras/backups/`
   - Nombre del archivo: `dtic_bitacoras_backup_YYYYMMDD_HHMMSS.sql`

2. **POST /api/system/restore**
   - Restaura la base de datos desde un archivo de backup seleccionado
   - Utiliza pg_restore con opciones --clean --if-exists --create
   - Requiere validación del archivo de backup

3. **GET /api/system/backups**
   - Lista todos los archivos de backup disponibles
   - Proporciona información de tamaño, fechas de creación y modificación
   - Ordena los backups por fecha descendente

#### Seguridad

- Todos los endpoints requieren autenticación JWT
- Solo usuarios con rol 'admin' pueden acceder
- Middleware de autorización implementado

#### Implementación Técnica

- Utiliza Docker para ejecutar comandos pg_dump y pg_restore
- Manejo de archivos temporales dentro del contenedor
- Limpieza automática de archivos temporales
- Manejo de errores completo con logging

### Frontend (UI)

#### Componente Sistema.tsx

- Página dedicada para administración del sistema
- Acceso restringido a usuarios administradores
- Interfaz intuitiva con cards para backup y restore

#### Funcionalidades de UI

1. **Crear Backup**
   - Botón con indicador de carga
   - Notificaciones toast de éxito/error
   - Actualización automática de la lista de backups

2. **Restaurar Backup**
   - Selector de backup con lista de archivos disponibles
   - Modal de confirmación con advertencia
   - Validación de selección requerida

3. **Historial de Backups**
   - Tabla responsive con información detallada
   - Formateo de tamaños de archivo y fechas
   - Botón de actualizar lista

#### Estados de Carga

- Loading inicial para cargar lista de backups
- Estados de carga específicos para backup y restore
- Deshabilitación de botones durante operaciones

#### Manejo de Errores

- Try-catch en todas las operaciones asíncronas
- Notificaciones toast para errores
- Logging en consola para debugging

## Flujo de Operaciones

### Crear Backup

1. Usuario hace clic en "Crear Backup"
2. Frontend envía POST a /api/system/backup
3. Backend ejecuta pg_dump en contenedor PostgreSQL
4. Archivo se copia al directorio de backups del host
5. Frontend actualiza lista de backups
6. Notificación de éxito

### Restaurar Backup

1. Usuario selecciona backup del dropdown
2. Hace clic en "Restaurar Backup"
3. Modal de confirmación se muestra
4. Usuario confirma la operación
5. Frontend envía POST a /api/system/restore con nombre del archivo
6. Backend ejecuta pg_restore
7. Notificación de éxito/error

## Consideraciones Técnicas

### Docker Integration

- Utiliza `docker exec` para comandos dentro del contenedor
- `docker cp` para transferir archivos entre contenedor y host
- Manejo de variables de entorno para credenciales

### Formato de Archivos

- Backups en formato SQL plano
- Nombres con timestamp ISO modificado
- Almacenamiento en directorio persistente

### Validaciones

- Verificación de existencia de archivos antes de restore
- Validación de permisos de usuario
- Sanitización de inputs

## Testing

La funcionalidad ha sido probada con:

- Creación exitosa de backups
- Restauración desde backups válidos
- Manejo de errores en archivos inexistentes
- Validación de permisos de usuario
- Interfaz responsive en diferentes dispositivos

## Conclusión

Esta implementación proporciona una solución completa y segura para la gestión de backups en el sistema DTIC Bitácoras, con una interfaz de usuario intuitiva y robusta implementación backend.