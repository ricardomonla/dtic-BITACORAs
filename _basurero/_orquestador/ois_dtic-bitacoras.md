---
title: "dtic-BITACORAs - Orquestador Específico"
version: "1.0.0"
author: "[DTIC Organization]"
description: "Orquestador específico para el proyecto dtic-BITACORAs, sistema de gestión de bitácoras del DTIC."
language: "es"
communication_policy: "spanish_only"
last_updated: "2025-11-17"
framework_type: "hybrid_markdown_yaml"
extensions: []
  # Placeholder for extension metadata
  # - name: "example_extension"
  #   version: "1.0.0"
  #   description: "Description of extension"
---

# dtic-BITACORAs - Orquestador Específico

Orquestador específico para el proyecto dtic-BITACORAs, sistema de gestión de bitácoras del DTIC.

## Índice de Orquestación

### Catálogo Estructurado

```yaml
# CONFIGURACIÓN AUTOMÁTICA DE ORQUESTACIÓN
orquestadores:
  base_universal:
    id: "DTIC-BASE-001"
    nombre: "Plantilla Base Universal"
    categoria: "general"
    prioridad: 1
    palabras_clave: ["general", "universal", "base", "cualquier"]
    patrones_matching: ["cualquier tarea", "general", "sin especificar"]
    uso_recomendado: "Cuando no se especifica un tipo de tarea específico"
    descripcion: "Plantilla base para cualquier tipo de desarrollo en DTIC Bitácoras"

  documentacion_workflow:
    id: "DTIC-DOC-001"
    nombre: "Documentación y Workflow de Desarrollo"
    categoria: "documentacion"
    prioridad: 1
    palabras_clave: ["documentar", "bitacora", "tareas completadas", "versionado", "commit", "verificacion", "changelog"]
    patrones_matching: ["documentar avance", "tareas completadas", "versionado", "commit", "changelog", "verificacion", "bitacora de desarrollo"]
    uso_recomendado: "Documentación de progreso de desarrollo y workflow de versionado"
    descripcion: "Plantilla para documentación de avances y workflow de desarrollo de 4 fases"

  desarrollo_frontend:
    id: "DTIC-FE-001"
    nombre: "Desarrollo Frontend (React + TypeScript)"
    categoria: "desarrollo"
    prioridad: 2
    palabras_clave: ["react", "typescript", "frontend", "componente", "ui", "interfaz", "hooks", "useState", "useEffect"]
    patrones_matching: ["desarrollo frontend", "implementar componente", "crear interfaz", "react con typescript", "hooks react"]
    uso_recomendado: "Desarrollo de interfaces de usuario y componentes React"
    descripcion: "Plantilla especializada para desarrollo frontend con React y TypeScript"

  desarrollo_backend:
    id: "DTIC-BE-001"
    nombre: "Desarrollo Backend (Node.js + Express)"
    categoria: "desarrollo"
    prioridad: 2
    palabras_clave: ["node.js", "express", "backend", "api", "endpoint", "server", "middleware"]
    patrones_matching: ["desarrollo backend", "crear api", "endpoint express", "server node", "middleware", "rutas rest"]
    uso_recomendado: "Desarrollo de APIs y servicios backend"
    descripcion: "Plantilla especializada para desarrollo backend con Node.js y Express"

  autenticacion_seguridad:
    id: "DTIC-AUTH-001"
    nombre: "Autenticación y Autorización"
    categoria: "seguridad"
    prioridad: 1
    palabras_clave: ["jwt", "autenticacion", "autorizacion", "token", "login", "logout", "seguridad", "permisos", "bcrypt"]
    patrones_matching: ["autenticación", "jwt", "login", "seguridad", "autorización", "tokens", "permisos", "middleware auth"]
    uso_recomendado: "Implementación de sistemas de autenticación y seguridad"
    descripcion: "Plantilla para funcionalidades de autenticación JWT y control de acceso"

  base_datos_gestion:
    id: "DTIC-DB-001"
    nombre: "Gestión de Base de Datos (PostgreSQL)"
    categoria: "datos"
    prioridad: 2
    palabras_clave: ["postgresql", "sql", "base de datos", "query", "tabla", "migración", "índices", "transacciones"]
    patrones_matching: ["base de datos", "postgresql", "query sql", "tabla", "migración", "optimizar base de datos", "índices"]
    uso_recomendado: "Operaciones de base de datos y optimización SQL"
    descripcion: "Plantilla para gestión y optimización de PostgreSQL"

  debugging_problemas:
    id: "DTIC-DEBUG-001"
    nombre: "Debugging y Solución de Problemas"
    categoria: "debugging"
    prioridad: 1
    palabras_clave: ["debug", "error", "problema", "bug", "fallo", "troubleshoot", "solucionar", "diagnóstico"]
    patrones_matching: ["debug", "error", "problema", "bug", "no funciona", "solución", "diagnóstico", "troubleshoot"]
    uso_recomendado: "Resolución de errores y problemas del sistema"
    descripcion: "Plantilla para debugging y solución de problemas técnicos"

  optimizacion_rendimiento:
    id: "DTIC-OPT-001"
    nombre: "Optimización y Mejora de Rendimiento"
    categoria: "optimizacion"
    prioridad: 2
    palabras_clave: ["optimizar", "rendimiento", "performance", "velocidad", "eficiencia", "memoria", "cache"]
    patrones_matching: ["optimizar", "rendimiento", "performance", "lento", "velocidad", "eficiencia", "memoria", "cache"]
    uso_recomendado: "Mejora del rendimiento y optimización del sistema"
    descripcion: "Plantilla para optimización y mejora de performance"

  configuracion_sistema:
    id: "DTIC-CONF-001"
    nombre: "Configuración del Sistema"
    categoria: "configuracion"
    prioridad: 2
    palabras_clave: ["docker", "configuración", "yaml", "env", "variables", "deployment", "setup", "instalación", "desplegar", "respaldo", "backup", "app-run.sh"]
    patrones_matching: ["docker", "configuración", "yaml", "variables de entorno", "deployment", "setup", "instalación"]
    uso_recomendado: "Configuración y deployment del sistema"
    descripcion: "Plantilla para configuración de Docker, YAML y variables de entorno"

  crud_entidades:
    id: "DTIC-CRUD-001"
    nombre: "Entidades CRUD y Stores Genéricos"
    categoria: "desarrollo"
    prioridad: 2
    palabras_clave: ["crud", "entidades", "create", "read", "update", "delete", "stores", "generic", "useEntityManagement"]
    patrones_matching: ["crud", "entidades", "crear", "leer", "actualizar", "eliminar", "stores genéricos", "useEntityManagement"]
    uso_recomendado: "Implementación de operaciones CRUD para entidades"
    descripcion: "Plantilla para desarrollo de funcionalidades CRUD con stores genéricos"

  dashboard_reportes:
    id: "DTIC-DASH-001"
    nombre: "Dashboard y Reportes"
    categoria: "reportes"
    prioridad: 2
    palabras_clave: ["dashboard", "reportes", "estadísticas", "gráficos", "métricas", "visualización", "charts"]
    patrones_matching: ["dashboard", "reportes", "estadísticas", "gráficos", "métricas", "visualización", "charts"]
    uso_recomendado: "Desarrollo de dashboards y sistemas de reportes"
    descripcion: "Plantilla para creación de dashboards y reportes estadísticos"

  mantenimiento_sistema:
    id: "DTIC-MAINT-001"
    nombre: "Mantenimiento y Limpieza del Sistema"
    categoria: "mantenimiento"
    prioridad: 2
    palabras_clave: ["mantenimiento", "limpieza", "archivos", "basurero", "organizar", "cleanup", "mover", "archivar", "sistema", "dtic", "bitacoras"]
    patrones_matching: ["mover a basurero", "limpiar archivos", "organizar documentacion", "archivar archivos innecesarios", "mantenimiento sistema"]
    uso_recomendado: "Realizar mantenimiento y limpieza de archivos innecesarios en el sistema DTIC Bitácoras"
    descripcion: "Plantilla para tareas de mantenimiento, limpieza y organización de archivos del sistema"

  documentacion_sistema_completa:
    id: "DTIC-DOCS-SYS-001"
    nombre: "Documentación del Sistema DTIC Bitácoras"
    categoria: "documentacion"
    prioridad: 1
    palabras_clave: ["documentar", "sistema", "documentacion", "arquitectura", "componentes", "modulos", "api", "base de datos", "frontend", "backend", "dtic", "bitacoras"]
    patrones_matching: ["documentar sistema", "documentacion completa", "arquitectura del sistema", "componentes del sistema", "documentar dtic bitacoras"]
    uso_recomendado: "Crear documentación completa del sistema DTIC Bitácoras utilizando información existente en _docs"
    descripcion: "Plantilla para documentar la arquitectura, componentes y funcionalidades del sistema DTIC Bitácoras"

  system_documentation_versioning:
    id: "DTIC-SYS-DOC-001"
    nombre: "System Documentation and Versioning Tasks"
    categoria: "documentacion"
    prioridad: 1
    palabras_clave: ["versioning", "documentation", "system", "version", "changelog", "update", "record", "database", "restore", "backup", "verification", "spanish", "package.json", "consistent"]
    patrones_matching: ["system documentation", "versioning tasks", "update versioning", "create version record", "database restore documentation", "system state documentation"]
    uso_recomendado: "Perform system documentation and versioning tasks including version updates, changelog entries, and system state documentation"
    descripcion: "Template for system documentation and versioning tasks, including database restore documentation, version updates, and system state recording. Mandatory requirements: CHANGELOG.md file must be maintained in Spanish language, not English and must use table format for each version entry with columns "Tipo" and "Descripción". Version updates must be applied consistently to both backend and frontend package.json files. Additionally, update hardcoded version displays in frontend UI code (e.g., Navbar.tsx) along with package.json updates. Implement dynamic version loading from package.json in Vite React apps by defining VERSION in vite.config.ts by reading package.json, and use import.meta.env.VERSION in components instead of hardcoding."

  task_resources_assignment:
    id: "DTIC-TASK-RESOURCES-001"
    nombre: "Problema de Asignación de Recursos en Tareas"
    categoria: "desarrollo"
    prioridad: 1
    palabras_clave: ["tareas", "recursos", "asignar", "editar", "agregar", "relacionados", "no funciona", "problema", "asignacion"]
    patrones_matching: ["no puedo agregar recursos", "problema asignar recursos tareas", "editar tarea recursos", "no se pueden agregar recursos relacionados", "asignación de recursos en tareas"]
    uso_recomendado: "Resolver problemas donde no se pueden agregar nuevos recursos relacionados al editar tareas"
    descripcion: "Plantilla para diagnosticar y resolver problemas de asignación de recursos relacionados en la edición de tareas"

  documentacion_completa_sistema:
    id: "DTIC-SYSTEM-DOCS-001"
    nombre: "Documentación Completa del Sistema DTIC Bitácoras"
    categoria: "documentacion"
    prioridad: 1
    palabras_clave: ["documentar", "sistema", "changelog", "readme", "sistema_dtic_bitacoras", "documentacion", "completa", "arquitectura", "componentes", "apis", "base_datos", "español", "package.json", "versionado consistente"]
    patrones_matching: ["documentar sistema", "actualizar documentacion", "changelog completo", "readme actualizado", "sistema_dtic_bitacoras.md", "documentacion completa", "arquitectura del sistema", "componentes documentados", "apis documentadas", "base de datos documentada"]
    uso_recomendado: "Documentar completamente el sistema DTIC Bitácoras en los archivos CHANGELOG.md, README.md y SISTEMA_DTIC_BITACORAS.md"
    descripcion: "Plantilla para documentación completa del sistema incluyendo arquitectura, componentes, APIs, base de datos y funcionalidades. Requisitos obligatorios: El archivo CHANGELOG.md debe mantenerse en idioma español, no inglés y debe utilizar formato de tabla para cada entrada de versión con columnas "Tipo" and "Descripción". Las actualizaciones de versión deben aplicarse de manera consistente en ambos archivos package.json de backend y frontend. Implementar carga dinámica de versión desde package.json en aplicaciones Vite React definiendo VERSION en vite.config.ts leyendo package.json, y usar import.meta.env.VERSION en componentes en lugar de hardcoding."

  actualizacion_documentacion:
    id: "DTIC-DOCS-UPD-001"
    nombre: "Actualización de Documentación"
    categoria: "documentacion"
    prioridad: 2
    palabras_clave: ["actualizar", "documentacion", "flujos", "workflows", "integrar", "incorporar", "mejorar", "sistema", "dtic", "bitacoras"]
    patrones_matching: ["actualizar documentacion", "incorporar flujos", "mejorar docs", "integrar workflows", "actualizar sistema docs"]
    uso_recomendado: "Actualizar la documentación del sistema con nueva información de flujos de trabajo"
    descripcion: "Plantilla para actualizar y mejorar la documentación del sistema DTIC Bitácoras"

  documentacion_entidades:
    id: "DTIC-DOCS-ENT-001"
    nombre: "Documentación de Entidades del Sistema"
    categoria: "documentacion"
    prioridad: 2
    palabras_clave: ["entidades", "configuracion", "yaml", "campos", "relaciones", "funcionalidades", "estados", "sistema", "dtic", "bitacoras"]
    patrones_matching: ["documentar entidades", "configuracion entidades", "entidades yaml", "documentar configuracion entidades"]
    uso_recomendado: "Documentar las entidades del sistema DTIC Bitácoras desde configuración YAML"
    descripcion: "Plantilla para documentar entidades y configuraciones del sistema"

  control_versiones_git:
    id: "DTIC-VC-001"
    nombre: "Control de Versiones y Git"
    categoria: "version_control"
    prioridad: 3
    palabras_clave: ["git", "commit", "push", "github", "version", "control", "repositorio", "branch", "merge", "pull"]
    patrones_matching: ["commit", "push github", "version control", "git operations", "subir cambios"]
    uso_recomendado: "Realizar operaciones de control de versiones con Git y GitHub"
    descripcion: "Plantilla para operaciones de version control y gestión de repositorio"

  database_restore:
    id: "DTIC-DB-RESTORE-001"
    nombre: "Database Restore - srvv-KOHA Resource Restored"
    categoria: "datos"
    prioridad: 1
    palabras_clave: ["restore", "backup", "database", "bd-restore", "srvv-KOHA", "verificación", "restauración", "script", "app-run.sh", "resolved", "successful"]
    patrones_matching: ["database restore", "bd-restore functionality", "srvv-KOHA resource restored", "backup verification", "restore script", "successful restore"]
    uso_recomendado: "Documentar restauración exitosa de base de datos y verificación de recursos"
    descripcion: "Plantilla para documentación de restauración exitosa de base de datos con resolución del problema de recurso srvv-KOHA faltante"

  database_restore_completed:
    id: "DTIC-DB-RESTORE-COMPLETED-001"
    nombre: "Database Restore Completed Documentation"
    categoria: "datos"
    prioridad: 2
    palabras_clave: ["restore", "backup", "database", "completed", "successful", "verification", "documentation", "bd-restore", "script", "app-run.sh"]
    patrones_matching: ["successful database restore", "restore completed", "document restore operation", "backup restore verification", "restore documentation"]
    uso_recomendado: "Documentar operaciones exitosas de restauración de base de datos"
    descripcion: "Plantilla para documentar restauraciones exitosas de base de datos con detalles de proceso y verificación"

  importacion_pdf:
    id: "DTIC-PDF-IMPORT-001"
    nombre: "Importación de Datos desde PDF"
    categoria: "datos"
    prioridad: 2
    palabras_clave: ["pdf", "importar", "extraer", "texto", "parsing", "mapeo", "base de datos", "error handling", "duplicados", "conexion", "multi-line", "estructurado"]
    patrones_matching: ["importar datos pdf", "extraer texto pdf", "cargar pdf a base de datos", "parsing pdf", "mapeo schema pdf", "insertar datos pdf", "manejo errores pdf", "duplicados pdf", "conexion bd pdf", "multi-line entries pdf"]
    uso_recomendado: "Importar datos desde archivos PDF a la base de datos con manejo de errores y validaciones"
    descripcion: "Plantilla para el proceso completo de importación de datos desde PDF: extracción de texto, parsing a datos estructurados, mapeo a schema de base de datos, inserción con error handling, y manejo de entradas multi-línea, duplicados y problemas de conexión"

  modificaciones_sistema:
    id: "DTIC-SYSTEM-001"
    nombre: "Modificaciones del Sistema"
    categoria: "sistema"
    prioridad: 1
    palabras_clave: ["sistema", "administracion", "modificaciones", "configuracion", "usuarios", "permisos", "seguridad", "gestion", "ajustes", "parametros"]
    patrones_matching: ["modificar sistema", "administrar sistema", "configurar sistema", "gestionar usuarios", "cambiar permisos", "ajustar configuracion", "seguridad sistema", "parametros sistema"]
    uso_recomendado: "Realizar modificaciones y administración del sistema DTIC Bitácoras, incluyendo configuración, usuarios y permisos"
    descripcion: "Plantilla para tareas de administración y modificaciones del sistema, incluyendo gestión de usuarios, permisos, configuraciones de seguridad y ajustes de parámetros del sistema"

  backup_restore_operations:
    id: "DTIC-BACKUP-RESTORE-001"
    nombre: "Backup and Restore Operations"
    categoria: "datos"
    prioridad: 1
    palabras_clave: ["backup", "restore", "database", "system administration", "delete", "download", "eliminar", "descargar", "archivos", "files"]
    patrones_matching: ["backup operations", "restore database", "system backup", "database restore", "backup and restore", "delete backup", "download backup", "eliminar backup", "descargar backup", "manage backup files", "gestionar archivos backup"]
    uso_recomendado: "Perform backup and restore operations for the DTIC Bitácoras system, including creating, restoring, deleting, and downloading backup files"
    descripcion: "Template for complete backup management operations including database backups, system state preservation, restoration procedures, file deletion, and download functionality"

  comandas_workflow:
    id: "DTIC-COMANDAS-001"
    nombre: "Gestión de Comandas de Trabajo"
    categoria: "documentacion"
    prioridad: 1
    palabras_clave: ["comanda", "avance", "registrar", "tareas completadas", "versionado", "changelog", "commit", "pendientes", "propuestas"]
    patrones_matching: ["comanda activa", "registrar avance", "finalizar comanda", "tareas completadas", "versionado sistema", "registro progresivo", "avances trabajo"]
    uso_recomendado: "Gestionar comandas de trabajo y registrar avances del proyecto"
    descripcion: "Plantilla para gestión de comandas: registro progresivo de cambios, tareas completadas y pendientes, y automatización de versionado, changelog y commit al registrar avance"

  # CLASIFICACIÓN AUTOMÁTICA
clasificacion:
  categorias:
   desarrollo: ["frontend", "backend", "crud"]
   seguridad: ["autenticacion"]
   datos: ["base_datos", "backup_restore", "pdf_import"]
   reportes: ["dashboard"]
   configuracion: ["deployment"]
   optimizacion: ["performance"]
   debugging: ["error_solving"]
   documentacion: ["workflow", "sistema", "actualizacion", "entidades", "system_documentation"]
   mantenimiento: ["cleanup"]
   version_control: ["git"]
   sistema: ["administracion"]

  priority_rules:
    - categoria: "seguridad"
      prioridad_alta: true
    - categoria: "documentacion"
      prioridad_alta: true
    - categoria: "debugging"
      prioridad_alta: true
    - categoria: "sistema"
      prioridad_alta: true
    - categoria: "datos"
      prioridad_alta: true

  match_algorithm:
    exact_match: true
    fuzzy_match: true
    weight_by_priority: true
    consider_subcategoria: true
```

## Lógica de Selección

### Algoritmo de Clasificación

```javascript
// Algoritmo de clasificación para dtic-BITACORAs
function selectOrchestrator(userPrompt) {
    const promptLower = userPrompt.toLowerCase();
    let bestOrchestrator = orchestrators.documentacion_sistema;
    let bestScore = 0;

    // Iterar por todos los orquestadores
    for (const orchestrator of Object.values(orchestrators)) {
        let score = 0;

        // Puntaje por coincidencias exactas de keywords
        for (const keyword of orchestrator.palabras_clave) {
            if (promptLower.includes(keyword.toLowerCase())) {
                score += 2;
            }
        }

        // Puntaje por patrones
        for (const pattern of orchestrator.patrones_matching) {
            if (promptLower.includes(pattern.toLowerCase())) {
                score += 3;
            }
        }

        // Bonus por prioridad
        score += (10 - orchestrator.prioridad) * 0.1;

        // Bonus por categoría
        if (promptLower.includes(orchestrator.categoria)) {
            score += 1;
        }

        if (score > bestScore) {
            bestScore = score;
            bestOrchestrator = orchestrator;
        }
    }

    return bestOrchestrator;
}
```

## Flujo de Trabajo

El flujo general sigue 4 fases obligatorias para cualquier solicitud, adaptándose al tipo específico.

### Fase 1: Análisis
- Evaluar la solicitud completa y contexto del proyecto dtic-BITACORAs.
- Identificar dependencias y requisitos previos.
- Registrar análisis en `proyecto_activo/_tareasTerminadas/` para trazabilidad.

### Fase 2: Planificación
- Generar plan detallado basado en orquestador seleccionado.
- Incluir bucle de confirmación: Presentar plan al usuario y obtener aprobación.
- Ajustar plan según feedback, repitiendo hasta validación.

### Fase 3: Implementación
- Ejecutar acciones automatizadas según el plan aprobado.
- Integrar con herramientas (Git, tests, etc.) para ejecución eficiente.
- Monitorear progreso y registrar avances en comandas activas.

### Fase 4: Validación
- Verificar resultados contra criterios definidos.
- Ejecutar tests y validaciones automáticas/manuales.
- Actualizar métricas y activar SCORRIG para optimización futura.
- Commit final con mensaje estructurado.

## Ejemplos de Uso

### Documentación del Sistema
"Documentar completamente el sistema DTIC Bitácoras incluyendo arquitectura y componentes"

**Análisis:** Solicitud de documentación completa del sistema
**Planificación:** Usar DTIC-DOCS-SYS-001 para generar documentación estructurada
**Implementación:** Crear archivos en _docs/ y actualizar SISTEMA_DTIC_BITACORAS.md
**Validación:** Verificar completitud y consistencia de la documentación

### Desarrollo Frontend
"Implementar un nuevo componente React para gestión de tareas"

**Análisis:** Solicitud de desarrollo frontend específico
**Planificación:** Usar DTIC-FE-001 para desarrollo con mejores prácticas
**Implementación:** Crear componente TypeScript con hooks y validación
**Validación:** Testing y integración en la aplicación

### Gestión de Base de Datos
"Optimizar queries de PostgreSQL para mejor rendimiento"

**Análisis:** Solicitud de optimización de base de datos
**Planificación:** Usar DTIC-DB-001 para análisis y mejoras
**Implementación:** Crear índices, optimizar queries y actualizar esquema
**Validación:** Medir mejoras de rendimiento y verificar integridad

## Referencias
- **Documentación del Sistema**: Ver `proyecto_activo/_app-bitacoras/SISTEMA_DTIC_BITACORAS.md` para documentación completa.
- **Prompts Framework**: Ubicadas en `dtic-BITACORAs/_prompts/prompts_app_dtic-BITACORAs.md` para automatización de tareas.
- **SCORRIG**: Sistema de auto-optimización integrado en todas las fases.

## Notas Adicionales
- **Idioma**: Procesamiento interno en inglés, interacciones en español
- **Automatización**: Integración completa con Framework de Prompts DTIC
- **Escalabilidad**: Diseño modular para expansión del sistema

---

## Política de Comunicación - REQUISITO CRÍTICO

**🚨 REQUISITO OBLIGATORIO: TODA LA COMUNICACIÓN DEBE SER EN ESPAÑOL**

Esta política es un **requisito crítico y no negociable** para todas las interacciones con el usuario.

### 📋 Requisitos Obligatorios

#### **Comunicación con el Usuario**
- ✅ **TODAS** las respuestas al usuario deben estar **exclusivamente en español**
- ✅ **TODAS** las explicaciones técnicas deben estar **en español**
- ✅ **TODAS** las documentaciones deben estar **en español**

#### **Contenido Prohibido**
- ❌ **NINGUNA** respuesta en inglés
- ❌ **NINGUNA** documentación en inglés

### 🔧 Procesamiento Interno (Permitido en inglés)
**ÚNICAMENTE** se permite inglés para código fuente y configuraciones técnicas.

### ⚖️ Reglas de Ejecución
#### **Validación Automática**
- El sistema debe validar que todas las respuestas estén en español
- Cualquier respuesta en inglés debe ser rechazada

---

## Historial de Versiones
- **Versión 1.0.0:** 2025-11-17 - Creación inicial del orquestador específico para dtic-BITACORAs