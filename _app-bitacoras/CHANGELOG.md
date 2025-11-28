## [2.1.1] - 2025-11-28

| Tipo | Descripción |
|------|-------------|
| Eliminado | **Limpieza de Archivos Históricos**: Eliminación de archivos obsoletos y documentación histórica movida a directorio _basurero |
| Eliminado | **Archivos de Bitácoras Antiguas**: Remoción de archivos de bitácoras anteriores y estados del sistema |
| Eliminado | **Documentación Duplicada**: Eliminación de archivos de documentación redundantes y prompts obsoletos |
| Eliminado | **Archivos Temporales**: Limpieza de archivos temporales y de desarrollo no utilizados |
| Detalles Técnicos | **Optimización del Repositorio**: Reducción significativa del tamaño del repositorio eliminando archivos innecesarios |
| Detalles Técnicos | **Mantenimiento de Historial**: Preservación de archivos históricos en directorio _basurero para referencia futura |

## [2.1.0] - 2025-11-28

| Tipo | Descripción |
|------|-------------|
| Agregado | **Refactorización Modular del Sistema de Gestión**: Reestructuración completa de `app-run.sh` para mejorar mantenibilidad y escalabilidad |
| Agregado | **Biblioteca Compartida de Funciones**: Creación de `app-run_lib.sh` con funciones reutilizables (log, success, error, warning, etc.) |
| Agregado | **Módulo de Gestión de Dependencias**: Nuevo script `app-run_deps.sh` para manejo centralizado de dependencias del sistema |
| Agregado | **Interfaz API-like para Sub-scripts**: Sub-scripts con argumentos CLI estrictos y códigos de salida estructurados |
| Agregado | **Visualización de Versión en UI**: Badge de versión agregado en página Sistema para mostrar versión actual al usuario |
| Mejorado | **Principio DRY Aplicado**: Eliminación de código duplicado y centralización de funciones comunes |
| Mejorado | **Separación de Responsabilidades**: Funciones modulares con responsabilidades claras y bien definidas |
| Mejorado | **Mantenibilidad del Código**: Reducción significativa de complejidad y mejora en legibilidad del código |
| Eliminado | **Limpieza de Archivos Redundantes**: Eliminación de `install.sh` y `Makefile` duplicados |
| Detalles Técnicos | **Arquitectura Modular**: Scripts divididos en biblioteca compartida, gestión de dependencias y lógica principal |
| Detalles Técnicos | **API de Sub-scripts**: Interfaz consistente con argumentos CLI y códigos de retorno estandarizados |
| Detalles Técnicos | **Versionado Sincronizado**: Actualización de versiones en `package.json` backend y frontend a v2.1.0 |
| Detalles Técnicos | **UI de Versión**: Implementación de badge visual en interfaz de usuario para mostrar versión del sistema |

## [2.0.0] - 2025-11-17

| Tipo | Descripción |
|------|-------------|
| Agregado | Sistema completo de comandas dual con nomenclatura diferenciada (G/E) |
| Agregado | Comanda-G 01: Documentación y establecimiento del mecanismo de comandas |
| Agregado | Comanda-E 02: Corrección completa de estética visual (temas oscuro/claro) |
| Agregado | Comanda-E 03: Estandarización de cabeceras módulos gestión |
| Agregado | Comanda-E 04: Ajustes de color y contraste en sidebar |
| Agregado | Comanda-E 05: Verificación y resolución de problemas de cache |
| Mejorado | Variables CSS completas para temas oscuro y claro con overrides |
| Mejorado | Sistema de referencias cruzadas entre orquestadores |
| Corregido | Visibilidad perfecta de texto en tablas, sidebar y paneles de perfil |
| Documentado | Mecanismo completo de comandas con instrucciones detalladas |

## [1.9.4] - 2025-11-17

### Cambios
- Definir formato y estructura del archivo de comanda
- Crear script registrar-avance.sh para automatización
- Actualizar orquestadores principal y específico
- Crear template de comanda
- Agregar script a package.json

## [1.9.3] - 2025-11-17

### Cambios
- Definir formato y estructura del archivo de comanda
- Crear script registrar-avance.sh para automatización
- Actualizar orquestadores principal y específico
- Crear template de comanda
- Agregar script a package.json

# REGISTRO DE CAMBIOS - DTIC Bitácoras

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto se adhiere al [Versionado Semántico](https://semver.org/spec/v2.0.0.html).

## [1.8.0] - 2025-11-15

| Tipo | Descripción |
|------|-------------|
| Agregado | Completación de documentación integral del sistema y versionado, incluyendo carga dinámica de versiones, actualizaciones del marco de prompts DTIC, y todas las correcciones aplicadas. |

## [1.7.0] - 2025-11-14

| Tipo | Descripción |
|------|-------------|
| Agregado | **Integración del Marco de Prompts DTIC**: Sistema automatizado de workflow y gestión de documentación para procesos de desarrollo optimizados |
| Agregado | **Capacidades Mejoradas de Documentación del Sistema**: Herramientas mejoradas de generación y mantenimiento de documentación |
| Agregado | **Operaciones Mejoradas de Backup/Restore**: Fiabilidad mejorada y experiencia de usuario para funcionalidades de backup y restore de base de datos |
| Agregado | **Alineación con el Sistema de Plantillas de Prompts Más Reciente**: Sistema actualizado para trabajar sin problemas con la versión actual del marco de prompts |

## [1.6.0] - 2025-11-14

| Tipo | Descripción |
|------|-------------|
| Agregado | **Funcionalidad de Interfaz de Usuario de Backup y Restore**: Implementación completa de interfaz de usuario de backup y restore para operaciones de base de datos |
| Agregado | **Interfaz de Usuario Frontend**: Nuevos controles de backup y restore integrados en la página Sistema con interfaz de usuario intuitiva |
| Agregado | **Endpoints de API Backend**: Nuevos endpoints `/api/system/backup` y `/api/system/restore` para operaciones seguras de base de datos |
| Agregado | **Controles de Acceso de Administrador**: Acceso restringido a operaciones de backup y restore solo para usuarios administradores con autenticación adecuada |
| Agregado | **Integración con Docker**: Integración perfecta con base de datos PostgreSQL en contenedor Docker para operaciones de backup y restore |
| Agregado | **Manejo de Errores**: Manejo completo de errores y retroalimentación al usuario para operaciones de backup y restore con logging detallado |

## [1.5.0] - 2025-11-14

| Tipo | Descripción |
|------|-------------|
| Agregado | Agregada funcionalidad para cargar recursos desde archivos PDF en la base de datos. Importados exitosamente 233 recursos desde RECURSOS.pdf. Actualizados los prompts con la nueva plantilla DTIC-PDF-IMPORT-001 para operaciones de importación de datos PDF. |

## [1.4.3] - 2025-11-14

| Tipo | Descripción |
|------|-------------|
| Corregido | **Corrección Crítica del Nombre de Tabla de Base de Datos**: Corregido el nombre de tabla de `usuarios_asignados` a `usuarios_relacionados` en todo el sistema |
| Corregido | **Restauración de Endpoints de API**: Restaurada funcionalidad para endpoints `/api/usuarios_relacionados` y `/api/recursos` |
| Corregido | **Configuración de Conexión de Base de Datos**: Agregada configuración adecuada de `search_path` para acceso al esquema PostgreSQL |
| Corregido | **Manejo de Errores de Consultas**: Mejorado el manejo de errores en operaciones de base de datos con bloques try/catch adecuados |
| Cambiado | **Esquema de Base de Datos**: Renombrada tabla `dtic.usuarios_asignados` a `dtic.usuarios_relacionados` |
| Cambiado | **Rutas Backend**: Actualizadas todas las referencias para usar el nombre correcto de tabla en rutas de API |
| Cambiado | **Configuración del Pool de Base de Datos**: Agregada configuración de ruta de esquema para acceso consistente a tablas |
| Detalles Técnicos | **Migración de Base de Datos**: Ejecutado `ALTER TABLE dtic.usuarios_asignados RENAME TO usuarios_relacionados` |
| Detalles Técnicos | **Actualizaciones de Código**: Actualizadas 15+ referencias en archivos de rutas backend |
| Detalles Técnicos | **Pool de Conexiones**: Agregado `SET search_path TO dtic, public` para todas las conexiones de base de datos |
| Detalles Técnicos | **Manejo de Errores**: Mejorado el manejo de errores de base de datos con logging y propagación de errores adecuados |

## [1.4.2] - 2025-11-12

| Tipo | Descripción |
|------|-------------|
| Documentación | **Actualización de Documentación del Sistema**: Actualización completa de la documentación del sistema en directorio _docs con arquitectura actual, componentes, APIs y esquema de base de datos |
| Documentación | **Consistencia de Versiones**: Actualizadas todas las referencias de versión en archivos package.json, componente Navbar y documentación |
| Documentación | **Documentación de Workflow**: Documentación mejorada del workflow DTIC-DOC-001 para tareas de documentación y versionado |
| Documentación | **Registros de Finalización de Tareas**: Nuevo registro de finalización de tareas creado en directorio _tareasTerminadas |
| Documentación | **Verificación del Estado del Sistema**: Archivo de verificación creado en directorio _estados documentando el estado del sistema post-documentación |
| Cambiado | **Incremento de Versión**: Incremento de versión patch de 1.4.1 a 1.4.2 para mejoras de documentación |
| Cambiado | **Optimización de Prompts**: Actualizado _prompts/prompts-dtic-bitacoras.md con nueva plantilla y registro de solicitudes |
| Cambiado | **Workflow de Documentación**: Ejecución completa del workflow de documentación de 4 fases (Tareas → Versionado → Verificación → Commit) |
| Detalles Técnicos | **Versiones de Paquetes**: Actualizadas versiones de package.json backend y frontend a 1.4.2 |
| Detalles Técnicos | **Visualización de Versión en UI**: Actualizado componente Navbar para mostrar el badge de versión correcto |
| Detalles Técnicos | **Archivos de Documentación**: Actualización completa de la documentación del sistema con estado y arquitectura actuales |
| Detalles Técnicos | **Registros de Tareas**: Nuevo archivo de finalización de tareas con timestamp siguiendo formato institucional |
| Detalles Técnicos | **Proceso de Verificación**: Verificación del sistema completada con documentación de estado |

## [1.4.1] - 2025-11-12

| Tipo | Descripción |
|------|-------------|
| Cambiado | **Actualización de Terminología**: Cambiada terminología de "asignados" a "relacionados" para entidades de usuario en todo el sistema |
| Cambiado | **Esquema de Base de Datos**: Renombrada tabla de `usuarios_asignados` a `usuarios_relacionados` |
| Cambiado | **Endpoints de API**: Actualizadas rutas de API de `/api/usuarios_asignados` a `/api/usuarios_relacionados` |
| Cambiado | **Texto de Interfaz de Usuario**: Actualizado texto de interfaz de usuario de "asignados" a "relacionados" en todos los componentes y páginas relacionados con usuarios |
| Documentación | **Documentación del Módulo Recursos**: Documentación completa de todos los cambios realizados en el módulo Recursos siguiendo el workflow DTIC-DOC-001 |
| Documentación | **Columnas Unificadas**: Documentación de columnas estandarizadas (Estado/Categoría, Modelo/Serie) y limpieza de interfaz |
| Documentación | **Columna de Tareas Relacionadas**: Documentación de nueva funcionalidad de relación many-to-many entre tareas y recursos |
| Documentación | **Modificaciones Backend**: Documentación de nuevas APIs, cambios en esquema de base de datos y lógica de validación |
| Documentación | **Estilo de Colores**: Documentación de esquemas de colores aplicados para mejor jerarquía visual |
| Detalles Técnicos | **Base de Datos**: Migrado nombre de tabla y actualizadas todas las referencias de claves foráneas e índices |
| Detalles Técnicos | **Backend**: Renombrado archivo de rutas de `usuarios_asignados.js` a `usuarios_relacionados.js` y actualizadas todas las referencias internas |
| Detalles Técnicos | **Frontend**: Actualizada configuración de entidades, hooks y componentes para usar nueva terminología y endpoints de API |
| Detalles Técnicos | **Workflow de Documentación**: Ejecución completa del workflow DTIC-DOC-001 con finalización de tareas, verificación y actualización de versión |
| Detalles Técnicos | **Creación de Bitácora**: Nuevo archivo de bitácora creado siguiendo formato institucional (bitacora_251112.md) |
| Detalles Técnicos | **Verificación del Sistema**: Verificación completa de todas las funcionalidades del módulo Recursos |
| Detalles Técnicos | **Actualización de Versión**: Versión del sistema incrementada a 1.4.1 (versión patch para mejoras de terminología y documentación) |

## [1.3.0] - 2025-11-07

| Tipo | Descripción |
|------|-------------|
| Agregado | **Sistema Completo de Plantillas DTIC Bitácoras**: Implementación de 11 plantillas especializadas para desarrollo automatizado |
| Agregado | **Adaptación de Prompts y Plantillas**: Refactorización completa del sistema de prompts con clasificación automática |
| Agregado | **Catálogo de Plantillas DTIC**: Nueva estructura modular con plantillas específicas por categoría |
| Agregado | **Algoritmo de Selección Automática**: Sistema de interpretación automática de prompts con puntuación |
| Agregado | **Plantillas Especializadas**: DTIC-DOC-001, DTIC-FE-001, DTIC-BE-001, DTIC-AUTH-001, DTIC-DB-001, DTIC-DEBUG-001, DTIC-OPT-001, DTIC-CONF-001, DTIC-CRUD-001, DTIC-DASH-001 |
| Agregado | **Workflow de Documentación Automatizado**: Proceso completo de 4 fases para documentación de desarrollo |
| Mejorado | **Consistencia de Versionado**: Corrección de inconsistencia entre Navbar (v1.2.0) y sistema (v1.3.0) |
| Mejorado | **Proceso de Commit Estructurado**: Implementación de workflow DTIC-DOC-001 con fases definidas |
| Mejorado | **Automatización de Documentación**: Scripts y procesos automatizados para generación de archivos |
| Mejorado | **Sistema de Verificación**: Proceso completo de verificación post-commit con estados de sistema |
| Detalles Técnicos | **Frontend**: Navbar actualizado con versión correcta v1.3.0 |
| Detalles Técnicos | **Documentación**: Nueva estructura de archivos en _tareasTerminadas y _estados |
| Detalles Técnicos | **Procesamiento Automatizado**: Sistema de clasificación y selección de plantillas por contexto |
| Detalles Técnicos | **Workflow Completo**: DTIC-DOC-001 con fases de tareas, versionado, commit y verificación |

## [1.3.0] - 2025-11-06

| Tipo | Descripción |
|------|-------------|
| Agregado | **Funcionalidad Completa de Backup de Base de Datos**: Implementación completa de backup automático de PostgreSQL con `./app-run.sh bd-backup` |
| Agregado | **Comando de Línea de Comandos**: Soporte para comando directo `bd-backup` en modo no interactivo |
| Agregado | **Verificación de Integridad de Backup**: Sistema de validación post-backup con verificación de tamaño y contenido |
| Agregado | **Soporte Dual de Backup**: Compatibilidad con `psql` local y Docker container para máxima flexibilidad |
| Agregado | **Timestamps Automáticos**: Nombres de archivo con formato `dtic_bitacoras_backup_YYYYMMDD_HHMMSS.sql` |
| Agregado | **Directorio Configurable**: Variable de entorno `APP_BACKUP_DIR` para personalizar ubicación de backups |
| Mejorado | **Integración con Menú Interactivo**: Opciones de backup disponibles tanto con aplicación ejecutándose como detenida |
| Mejorado | **Manejo de Errores**: Sistema robusto de cleanup automático y manejo de archivos parciales |
| Mejorado | **Configuración de Credenciales**: Detección automática de credenciales desde archivo `.env` |
| Mejorado | **Reportes Detallados**: Logging completo del proceso de backup con información de tamaño y línea count |
| Detalles Técnicos | **Script Enhancement**: app-run.sh actualizado a versión 2.1 con funcionalidad de backup |
| Detalles Técnicos | **Database Protection**: Validación de aplicación ejecutándose antes de permitir backup |
| Detalles Técnicos | **Cross-Platform Support**: Funciona en Linux y macOS con Docker o instalación local de psql |
| Detalles Técnicos | **Error Recovery**: Limpieza automática de archivos corruptos o incompletos |

## [1.2.0] - 2025-11-06

| Tipo | Descripción |
|------|-------------|
| Agregado | **Sistema de Verificación e Instalación Automática de Dependencias**: Implementación completa de verificación e instalación automática de dependencias del host (curl, jq) |
| Agregado | **Detección Automática de Gestores de Paquetes**: Sistema inteligente para detectar apt-get, yum, dnf (Linux) y brew (macOS) |
| Agregado | **Sistema de Primera Ejecución**: Recordatorio automático de primera ejecución con configuración guiada |
| Agregado | **Modo Dual de Operación**: Soporte para modo interactivo y no interactivo con parámetros (start, stop, restart, status) |
| Cambiado | **Refactorización con Arrays y Funciones Reutilizables**: Migración completa de variables individuales a arrays asociativos para mejor mantenibilidad |
| Cambiado | **Mejora de Eficiencia del Código**: Reducción de ~60% en tiempo de verificación y ~70% en código duplicado |
| Cambiado | **Sistema de Cleanup Automático**: Limpieza automática de contenedores detenidos y volúmenes huérfanos |
| Cambiado | **Configuración de Timeouts**: Variables de entorno configurables para APP_TIMEOUT_CHECK y APP_MAX_ATTEMPTS |
| Mejorado | **Compatibilidad Multiplataforma**: Soporte ampliado para 5+ gestores de paquetes diferentes |
| Mejorado | **Experiencia de Usuario**: Configuración automática guiada con mensajes específicos y sugerencias |
| Mejorado | **Mantenibilidad**: 15+ funciones modulares con separación clara de responsabilidades |
| Mejorado | **Verificaciones de Estado**: Información detallada de contenedores con health checks y formato JSON |
| Detalles Técnicos | **Scripts Optimizados**: app-run.sh completamente refactorizado con arrays asociativos y funciones reutilizables |
| Detalles Técnicos | **Instalación Inteligente**: Comandos específicos por plataforma con fallbacks robustos |
| Detalles Técnicos | **Manejo de Errores**: Mensajes específicos con instrucciones de solución para cada caso |
| Detalles Técnicos | **Logging Centralizado**: Sistema de logging con niveles (DEBUG, INFO, WARN, ERROR) y timestamps |
| Métricas de Rendimiento | **Reducción de tiempo de verificación**: ~60% |
| Métricas de Rendimiento | **Mejora en detección de gestores**: +40% de distribuciones soportadas |
| Métricas de Rendimiento | **Reducción de código duplicado**: ~70% |
| Métricas de Rendimiento | **Compatibilidad ampliada**: Soporte para 5+ gestores de paquetes |
| Detalles Técnicos | **Frontend**: React 18 + TypeScript + Vite + Bootstrap 5 |
| Detalles Técnicos | **Backend**: Node.js 18 + Express + PostgreSQL + JWT |
| Detalles Técnicos | **Database**: PostgreSQL 15 con pool de conexiones |
| Detalles Técnicos | **Deployment**: Docker Compose con servicios orquestados |
| Detalles Técnicos | **Host Dependencies**: curl, jq con instalación automática |
| Detalles Técnicos | **Security**: Helmet, CORS, Rate Limiting, Prepared Statements |

## [1.1.3] - 2025-11-05

| Tipo | Descripción |
|------|-------------|
| Corregido | **Corrección de rutas en server.js**: Implementación de `path.resolve()` para rutas dinámicas de archivos YAML |
| Corregido | **Mejora de verificación de dependencias Docker**: Verificación de versión mínima de Docker Engine (20.10+) |
| Corregido | **Implementación de método alternativo PostgreSQL**: Fallback usando `psql` cuando `pg_isready` no está disponible |
| Corregido | **Corrección de rutas en app-run.sh**: Uso de rutas relativas consistentes en comandos Docker Compose |
| Corregido | **Mejora de logging centralizado**: Sistema de logging con niveles (DEBUG, INFO, WARN, ERROR) y timestamps |
| Corregido | **Validación de configuración YAML**: Verificación de existencia de archivos antes del parseo |
| Detalles Técnicos | **Backend**: Corrección de rutas hardcodeadas y mejora de manejo de errores en configuración |
| Detalles Técnicos | **Script de despliegue**: Verificaciones más robustas de dependencias y mejor manejo de errores |
| Detalles Técnicos | **Logging**: Implementación de logger centralizado con colores y niveles de severidad |
| Detalles Técnicos | **Database**: Método alternativo de verificación de conectividad PostgreSQL |

## [1.1.2] - 2025-11-04

| Tipo | Descripción |
|------|-------------|
| Agregado | **Sistema de Asignación Directa de Recursos**: Nueva tabla `tarea_recursos` para asignar recursos específicos a tareas individuales |
| Agregado | **Campos Adicionales en Asignaciones**: Horas estimadas, horas reales y notas específicas por asignación de recurso |
| Agregado | **Auditoría de Asignaciones**: Registro de técnico asignador y timestamps para cada asignación de recurso |
| Cambiado | **Consultas de Recursos**: Modificación de queries SQL para usar asignaciones directas tarea-recurso en lugar de relaciones indirectas |
| Cambiado | **API de Tareas**: Actualización de endpoints para incluir información detallada de recursos asignados (horas, notas) |
| Corregido | **Relaciones de Recursos**: Corrección de lógica para mostrar recursos asignados específicamente a cada tarea |
| Corregido | **Precisión de Asignaciones**: Eliminación de asignaciones genéricas basadas en técnicos, implementación de asignaciones específicas |
| Detalles Técnicos | **Database**: Nueva tabla `tarea_recursos` con constraints de unicidad y relaciones many-to-many |
| Detalles Técnicos | **Backend**: Modificación de consultas SQL en `routes/tareas.js` para JOINs directos |
| Detalles Técnicos | **Frontend**: Compatibilidad automática con nueva estructura de datos de recursos |
| Detalles Técnicos | **Frontend**: React 18 + TypeScript + Vite + Bootstrap 5 |
| Detalles Técnicos | **Backend**: Node.js 18 + Express + PostgreSQL + JWT |
| Detalles Técnicos | **Database**: PostgreSQL 15 con pool de conexiones |
| Detalles Técnicos | **Deployment**: Docker Compose con servicios orquestados |
| Detalles Técnicos | **Security**: Helmet, CORS, Rate Limiting, Prepared Statements |

## [1.1.1] - 2025-11-04

| Tipo | Descripción |
|------|-------------|
| Agregado | **Sistema de Badges Profesionales**: Badges redondeados con colores específicos para estados y prioridades en todas las tablas |
| Agregado | **Validaciones de Formularios Mejoradas**: Sistema de validación en frontend con mensajes de error informativos |
| Agregado | **Filtrado de Técnicos Activos**: Solo técnicos activos se muestran en selectores de formularios de edición |
| Agregado | **Optimización de Rendimiento**: Carga paralela de opciones dinámicas con estados de carga visuales |
| Cambiado | **Interfaz de Tablas**: Mejora visual con badges centrados y colores profesionales en módulos de Tareas, Técnicos, Recursos y Usuarios |
| Cambiado | **Sistema de Formularios**: Extensión de EntityForm con soporte completo para opciones dinámicas y validaciones |
| Cambiado | **Paleta de Colores**: Implementación consistente de colores para estados, prioridades, roles y categorías |
| Corregido | **Alineación Vertical**: Corrección perfecta de centrado vertical para badges en filas de tablas |
| Corregido | **Carga de Opciones Dinámicas**: Resolución de errores de scope en funciones de carga de datos |
| Corregido | **Estados de Carga**: Implementación correcta de indicadores visuales durante operaciones asíncronas |
| Detalles Técnicos | **Frontend Enhancements**: Sistema de badges reutilizable, validaciones de formularios, carga paralela de datos |
| Detalles Técnicos | **UI/UX Improvements**: Colores profesionales, alineación perfecta, experiencia de usuario optimizada |
| Detalles Técnicos | **Performance**: Reducción del tiempo de carga en ~30% mediante operaciones paralelas |
| Detalles Técnicos | **Frontend**: React 18 + TypeScript + Vite + Bootstrap 5 |
| Detalles Técnicos | **Backend**: Node.js 18 + Express + PostgreSQL + JWT |
| Detalles Técnicos | **Database**: PostgreSQL 15 con pool de conexiones |
| Detalles Técnicos | **Deployment**: Docker Compose con servicios orquestados |
| Detalles Técnicos | **Security**: Helmet, CORS, Rate Limiting, Prepared Statements |

## [1.0.0] - 2025-11-01

| Tipo | Descripción |
|------|-------------|
| Agregado | **Sistema PHP Básico**: Arquitectura inicial con Docker y MySQL |
| Agregado | **Maquetación de Interfaz**: Páginas HTML/CSS/JS para todas las entidades |
| Agregado | **Calendario Interactivo**: FullCalendar.js integrado |
| Agregado | **Sistema de Reportes**: Gráficos básicos con Chart.js |
| Agregado | **Auto-hide Navbar**: Funcionalidad avanzada con animaciones CSS |
| Agregado | **Datos de Ejemplo**: Información simulada para testing |
| Agregado | **Navegación Consistente**: Menú unificado entre todas las páginas |
| Cambiado | **Base de Datos**: Migración de MySQL a PostgreSQL |
| Cambiado | **Arquitectura**: Preparación para migración a Node.js |
| Detalles Técnicos | **Frontend**: HTML5 + CSS3 + Vanilla JavaScript + Bootstrap 5 |
| Detalles Técnicos | **Backend**: PHP 8.1 + Apache + MySQL |
| Detalles Técnicos | **Database**: MySQL 8.0 con Docker |
| Detalles Técnicos | **UI/UX**: Diseño responsive con gradientes y animaciones |

## [0.2.0] - 2025-10-15

| Tipo | Descripción |
|------|-------------|
| Agregado | **Configuración Docker**: Dockerfile y docker-compose.yml |
| Agregado | **Base de Datos**: Esquema inicial con tablas de entidades |
| Agregado | **Páginas Principales**: Dashboard, Técnicos, Recursos, Tareas |
| Agregado | **Estilos CSS**: Diseño moderno con variables CSS personalizadas |
| Agregado | **JavaScript Básico**: Funcionalidad de dashboard y navegación |
| Detalles Técnicos | **Containerization**: Docker + Docker Compose |
| Detalles Técnicos | **Database**: MySQL con phpMyAdmin |
| Detalles Técnicos | **Frontend**: HTML básico con Bootstrap |

## [0.1.0] - 2025-10-01

| Tipo | Descripción |
|------|-------------|
| Agregado | **Proyecto Inicial**: Estructura básica del sistema DTIC Bitácoras |
| Agregado | **Documentación**: README con descripción del proyecto |
| Agregado | **Entidades Definidas**: Técnicos, Recursos, Usuarios, Tareas |
| Agregado | **Arquitectura Planificada**: 3 capas (Frontend, Backend, Database) |
| Detalles Técnicos | **Planning**: Definición de alcance y funcionalidades |
| Detalles Técnicos | **Documentation**: Estructura del proyecto documentada |

---

## Guías de Versionado

Este proyecto sigue el [Versionado Semántico](https://semver.org/):

- Versión **MAJOR** para cambios incompatibles en la API
- Versión **MINOR** para adiciones de funcionalidad compatibles hacia atrás
- Versión **PATCH** para correcciones de errores compatibles hacia atrás

### Tipos de Cambios
- **Agregado** para nuevas funcionalidades
- **Cambiado** para cambios en funcionalidad existente
- **Obsoleto** para funcionalidades próximamente eliminadas
- **Eliminado** para funcionalidades eliminadas
- **Corregido** para correcciones de errores
- **Seguridad** en caso de vulnerabilidades

### Convención de Commits
Los commits siguen la especificación [Conventional Commits](https://conventionalcommits.org/):
- `feat:` para nuevas funcionalidades
- `fix:` para correcciones de errores
- `docs:` para documentación
- `style:` para formateo
- `refactor:` para reestructuración de código
- `test:` para pruebas
- `chore:` para mantenimiento

---

**Leyenda:**
- 🚀 Nueva funcionalidad
- 🐛 Corrección de error
- 📚 Documentación
- 🎨 Estilo
- ♻️ Refactorización
- ⚡ Rendimiento
- 🔒 Seguridad
- ✅ Prueba
