import { useEffect, useState } from 'react'
import { useAuthStore } from '../stores/authStore'
import toast from 'react-hot-toast'

interface BackupFile {
  filename: string
  size: number
  created_at: string
  modified_at: string
}

const Sistema = () => {
  const { user, token } = useAuthStore()
  const [backups, setBackups] = useState<BackupFile[]>([])
  const [loading, setLoading] = useState(true)
  const [backupLoading, setBackupLoading] = useState(false)
  const [restoreLoading, setRestoreLoading] = useState(false)
  const [deleteLoading, setDeleteLoading] = useState<string | null>(null)
  const [downloadLoading, setDownloadLoading] = useState<string | null>(null)
  const [selectedBackup, setSelectedBackup] = useState<string>('')
  const [showRestoreConfirm, setShowRestoreConfirm] = useState(false)
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false)
  const [backupToDelete, setBackupToDelete] = useState<string>('')

  // Check if user is admin
  if (!user || user.role !== 'admin') {
    return (
      <div className="container mt-4">
        <div className="row justify-content-center">
          <div className="col-md-6">
            <div className="card border-danger">
              <div className="card-body text-center">
                <i className="fas fa-shield-alt fa-3x text-danger mb-3"></i>
                <h4 className="card-title text-danger">Acceso Denegado</h4>
                <p className="card-text">
                  Solo los administradores pueden acceder a esta sección del sistema.
                </p>
                <p className="text-muted">
                  Si crees que deberías tener acceso, contacta al administrador del sistema.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  useEffect(() => {
    loadBackups()
  }, [])

  const loadBackups = async () => {
    try {
      setLoading(true)
      console.log('Sistema loadBackups: user:', user, 'token:', !!token)
      const response = await fetch('/api/system/backups', {
        headers: {
          'Authorization': `Bearer ${token}`,
        },
      })

      console.log('Backups response status:', response.status)
      console.log('Backups response ok:', response.ok)

      if (!response.ok) {
        const errorText = await response.text()
        console.error('Backups response error text:', errorText)
        throw new Error(`HTTP ${response.status}: ${errorText}`)
      }

      const data = await response.json()
      console.log('Backups response data:', data)

      if (data.success) {
        setBackups(data.data.backups)
      } else {
        throw new Error(data.message || 'Error al cargar los backups')
      }
    } catch (error) {
      console.error('Error loading backups:', error)
      toast.error('Error al cargar la lista de backups')
    } finally {
      setLoading(false)
    }
  }

  const handleCreateBackup = async () => {
    try {
      setBackupLoading(true)
      console.log('handleCreateBackup: Starting backup creation')

      // Create AbortController for timeout
      const controller = new AbortController()
      const timeoutId = setTimeout(() => controller.abort(), 60000) // 60 second timeout for backup operations

      const response = await fetch('/api/system/backup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        signal: controller.signal,
      })

      clearTimeout(timeoutId)
      console.log('handleCreateBackup: Response status:', response.status)
      console.log('handleCreateBackup: Response ok:', response.ok)

      if (!response.ok) {
        const errorText = await response.text()
        console.error('handleCreateBackup: Response error text:', errorText)
        throw new Error(`HTTP ${response.status}: ${errorText}`)
      }

      const data = await response.json()
      console.log('handleCreateBackup: Response data:', data)

      if (data.success) {
        toast.success('Backup creado exitosamente')
        // Reload backups list
        await loadBackups()
      } else {
        throw new Error(data.message || 'Error al crear el backup')
      }
    } catch (error) {
      console.error('Error creating backup:', error)
      if (error instanceof Error && error.name === 'AbortError') {
        toast.error('Timeout: La creación del backup tomó demasiado tiempo')
      } else {
        toast.error('Error al crear el backup')
      }
    } finally {
      setBackupLoading(false)
    }
  }

  const handleRestoreBackup = async () => {
    if (!selectedBackup) {
      toast.error('Selecciona un backup para restaurar')
      return
    }

    try {
      setRestoreLoading(true)
      const response = await fetch('/api/system/restore', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify({ backup_file: selectedBackup }),
      })

      const data = await response.json()

      if (data.success) {
        toast.success('Base de datos restaurada exitosamente')
        setShowRestoreConfirm(false)
        setSelectedBackup('')
      } else {
        throw new Error(data.message || 'Error al restaurar el backup')
      }
    } catch (error) {
      console.error('Error restoring backup:', error)
      toast.error('Error al restaurar el backup')
    } finally {
      setRestoreLoading(false)
    }
  }

  const formatFileSize = (bytes: number) => {
    if (bytes === 0) return '0 Bytes'
    const k = 1024
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('es-AR', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    })
  }

  const confirmRestore = () => {
    if (!selectedBackup) {
      toast.error('Selecciona un backup para restaurar')
      return
    }
    setShowRestoreConfirm(true)
  }

  const handleDownloadBackup = async (filename: string) => {
    try {
      setDownloadLoading(filename)
      console.log('handleDownloadBackup: Starting download for', filename)

      const response = await fetch(`/api/system/backups/${filename}/download`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${token}`,
        },
      })

      if (!response.ok) {
        const errorText = await response.text()
        console.error('handleDownloadBackup: Response error text:', errorText)
        throw new Error(`HTTP ${response.status}: ${errorText}`)
      }

      // Create a blob from the response
      const blob = await response.blob()

      // Create a download link and trigger the download
      const url = window.URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = filename
      document.body.appendChild(a)
      a.click()
      window.URL.revokeObjectURL(url)
      document.body.removeChild(a)

      toast.success(`Backup ${filename} descargado exitosamente`)
    } catch (error) {
      console.error('Error downloading backup:', error)
      toast.error('Error al descargar el backup')
    } finally {
      setDownloadLoading(null)
    }
  }

  const handleDeleteBackup = async () => {
    if (!backupToDelete) {
      toast.error('No se seleccionó ningún backup para eliminar')
      return
    }

    try {
      setDeleteLoading(backupToDelete)
      console.log('handleDeleteBackup: Starting deletion for', backupToDelete)

      const response = await fetch(`/api/system/backups/${backupToDelete}`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`,
        },
      })

      if (!response.ok) {
        const errorText = await response.text()
        console.error('handleDeleteBackup: Response error text:', errorText)
        throw new Error(`HTTP ${response.status}: ${errorText}`)
      }

      const data = await response.json()
      console.log('handleDeleteBackup: Response data:', data)

      if (data.success) {
        toast.success('Backup eliminado exitosamente')
        setShowDeleteConfirm(false)
        setBackupToDelete('')
        // Reload backups list
        await loadBackups()
      } else {
        throw new Error(data.message || 'Error al eliminar el backup')
      }
    } catch (error) {
      console.error('Error deleting backup:', error)
      toast.error('Error al eliminar el backup')
    } finally {
      setDeleteLoading(null)
    }
  }

  const confirmDelete = (filename: string) => {
    setBackupToDelete(filename)
    setShowDeleteConfirm(true)
  }

  if (loading) {
    return (
      <div className="container mt-4">
        <div className="text-center py-5">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Cargando...</span>
          </div>
          <p className="mt-3">Cargando sistema...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="container mt-4">
      {/* Header */}
      <div className="row mb-4">
        <div className="col-12">
          <div className="d-flex align-items-center mb-3">
            <i className="fas fa-server fa-2x text-primary me-3"></i>
            <div>
              <h1 className="h3 mb-0">Sistema - Backup y Restauración</h1>
              <p className="text-muted mb-0">Gestión de backups de la base de datos</p>
            </div>
          </div>
        </div>
      </div>

      {/* Backup Section */}
      <div className="row mb-4">
        <div className="col-md-6">
          <div className="card h-100">
            <div className="card-header">
              <i className="fas fa-save text-success me-2"></i>
              Crear Backup
            </div>
            <div className="card-body text-center">
              <i className="fas fa-database fa-3x text-success mb-3"></i>
              <p className="card-text mb-4">
                Crea un backup completo de la base de datos del sistema.
                Los backups se almacenan automáticamente en el servidor.
              </p>
              <button
                className="btn btn-success btn-lg"
                onClick={handleCreateBackup}
                disabled={backupLoading}
              >
                {backupLoading ? (
                  <>
                    <span className="spinner-border spinner-border-sm me-2" role="status"></span>
                    Creando Backup... (puede tomar hasta 1 minuto)
                  </>
                ) : (
                  <>
                    <i className="fas fa-save me-2"></i>
                    Crear Backup
                  </>
                )}
              </button>
            </div>
          </div>
        </div>

        {/* Restore Section */}
        <div className="col-md-6">
          <div className="card h-100">
            <div className="card-header">
              <i className="fas fa-undo text-warning me-2"></i>
              Restaurar Backup
            </div>
            <div className="card-body text-center">
              <i className="fas fa-history fa-3x text-warning mb-3"></i>
              <p className="card-text mb-4">
                Restaura la base de datos desde un backup anterior.
                Esta acción sobrescribirá todos los datos actuales.
              </p>

              <div className="mb-3">
                <select
                  className="form-select"
                  value={selectedBackup}
                  onChange={(e) => setSelectedBackup(e.target.value)}
                >
                  <option value="">Seleccionar backup...</option>
                  {backups.map((backup) => (
                    <option key={backup.filename} value={backup.filename}>
                      {backup.filename} - {formatDate(backup.created_at)}
                    </option>
                  ))}
                </select>
              </div>

              <button
                className="btn btn-warning btn-lg"
                onClick={confirmRestore}
                disabled={!selectedBackup || restoreLoading}
              >
                {restoreLoading ? (
                  <>
                    <span className="spinner-border spinner-border-sm me-2" role="status"></span>
                    Restaurando...
                  </>
                ) : (
                  <>
                    <i className="fas fa-undo me-2"></i>
                    Restaurar Backup
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Backup History */}
      <div className="row">
        <div className="col-12">
          <div className="card">
            <div className="card-header d-flex justify-content-between align-items-center">
              <div>
                <i className="fas fa-list text-info me-2"></i>
                Historial de Backups
              </div>
              <button
                className="btn btn-sm btn-outline-primary"
                onClick={loadBackups}
                disabled={loading}
              >
                <i className="fas fa-sync me-1"></i>
                Actualizar
              </button>
            </div>
            <div className="card-body">
              {backups.length > 0 ? (
                <div className="table-responsive">
                  <table className="table table-hover">
                    <thead>
                       <tr>
                         <th>Archivo</th>
                         <th>Tamaño</th>
                         <th>Fecha de Creación</th>
                         <th>Última Modificación</th>
                         <th>Acciones</th>
                       </tr>
                     </thead>
                    <tbody>
                      {backups.map((backup) => (
                        <tr key={backup.filename}>
                          <td>
                            <i className="fas fa-file-archive text-secondary me-2"></i>
                            {backup.filename}
                          </td>
                          <td>{formatFileSize(backup.size)}</td>
                          <td>{formatDate(backup.created_at)}</td>
                          <td>{formatDate(backup.modified_at)}</td>
                          <td>
                            <div className="btn-group btn-group-sm" role="group">
                              <button
                                className="btn btn-outline-primary btn-sm"
                                onClick={() => handleDownloadBackup(backup.filename)}
                                disabled={downloadLoading === backup.filename}
                                title="Descargar backup"
                              >
                                {downloadLoading === backup.filename ? (
                                  <span className="spinner-border spinner-border-sm" role="status"></span>
                                ) : (
                                  <i className="fas fa-download"></i>
                                )}
                              </button>
                              <button
                                className="btn btn-outline-danger btn-sm"
                                onClick={() => confirmDelete(backup.filename)}
                                disabled={deleteLoading === backup.filename}
                                title="Eliminar backup"
                              >
                                {deleteLoading === backup.filename ? (
                                  <span className="spinner-border spinner-border-sm" role="status"></span>
                                ) : (
                                  <i className="fas fa-trash"></i>
                                )}
                              </button>
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <div className="text-center py-4">
                  <i className="fas fa-inbox fa-3x text-muted mb-3"></i>
                  <p className="text-muted">No hay backups disponibles</p>
                  <small className="text-muted">
                    Los backups aparecerán aquí una vez que se creen
                  </small>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Restore Confirmation Modal */}
      {showRestoreConfirm && (
        <div className="modal show d-block" tabIndex={-1}>
          <div className="modal-dialog modal-dialog-centered">
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title">
                  <i className="fas fa-exclamation-triangle text-warning me-2"></i>
                  Confirmar Restauración
                </h5>
                <button
                  type="button"
                  className="btn-close"
                  onClick={() => setShowRestoreConfirm(false)}
                ></button>
              </div>
              <div className="modal-body">
                <div className="alert alert-warning">
                  <i className="fas fa-exclamation-triangle me-2"></i>
                  <strong>Advertencia:</strong> Esta acción restaurará la base de datos
                  desde el backup seleccionado. Todos los datos actuales serán sobrescritos
                  y se perderán los cambios realizados después de la fecha del backup.
                </div>
                <p>¿Estás seguro de que deseas continuar?</p>
                <div className="text-muted small">
                  <strong>Backup seleccionado:</strong> {selectedBackup}
                </div>
              </div>
              <div className="modal-footer">
                <button
                  type="button"
                  className="btn btn-secondary"
                  onClick={() => setShowRestoreConfirm(false)}
                >
                  Cancelar
                </button>
                <button
                  type="button"
                  className="btn btn-warning"
                  onClick={handleRestoreBackup}
                  disabled={restoreLoading}
                >
                  {restoreLoading ? (
                    <>
                      <span className="spinner-border spinner-border-sm me-2"></span>
                      Restaurando...
                    </>
                  ) : (
                    'Confirmar Restauración'
                  )}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {showDeleteConfirm && (
        <div className="modal show d-block" tabIndex={-1}>
          <div className="modal-dialog modal-dialog-centered">
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title">
                  <i className="fas fa-exclamation-triangle text-danger me-2"></i>
                  Confirmar Eliminación
                </h5>
                <button
                  type="button"
                  className="btn-close"
                  onClick={() => setShowDeleteConfirm(false)}
                ></button>
              </div>
              <div className="modal-body">
                <div className="alert alert-danger">
                  <i className="fas fa-exclamation-triangle me-2"></i>
                  <strong>Advertencia:</strong> Esta acción eliminará permanentemente el archivo de backup.
                  Una vez eliminado, no podrá ser recuperado.
                </div>
                <p>¿Estás seguro de que deseas eliminar este backup?</p>
                <div className="text-muted small">
                  <strong>Archivo a eliminar:</strong> {backupToDelete}
                </div>
              </div>
              <div className="modal-footer">
                <button
                  type="button"
                  className="btn btn-secondary"
                  onClick={() => setShowDeleteConfirm(false)}
                >
                  Cancelar
                </button>
                <button
                  type="button"
                  className="btn btn-danger"
                  onClick={handleDeleteBackup}
                  disabled={deleteLoading !== null}
                >
                  {deleteLoading ? (
                    <>
                      <span className="spinner-border spinner-border-sm me-2"></span>
                      Eliminando...
                    </>
                  ) : (
                    'Confirmar Eliminación'
                  )}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Modal Backdrop */}
      {(showRestoreConfirm || showDeleteConfirm) && (
        <div className="modal-backdrop show"></div>
      )}
    </div>
  )
}

export default Sistema