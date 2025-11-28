#!/bin/bash

# =============================================================================
# DTIC Bitácoras - Script Optimizado de Gestión de Aplicación
# =============================================================================
#
# Script optimizado para gestión completa de la aplicación DTIC Bitácoras
# Soporta modos interactivo y no interactivo con parámetros
#
# Características:
#   - Modo interactivo (sin parámetros) con menús inteligentes
#   - Modo no interactivo con parámetros: start, stop, restart, status
#   - Verificación robusta de dependencias (Docker, docker-compose)
#   - Validación completa de PostgreSQL y servicios
#   - Cleanup automático de recursos huérfanos
#   - Timeouts configurables vía variables de entorno
#
# Uso:
#   ./app-run.sh              # Modo interactivo
#   ./app-run.sh start        # Iniciar aplicación (no interactivo)
#   ./app-run.sh stop         # Detener aplicación (no interactivo)
#   ./app-run.sh restart      # Reiniciar aplicación (no interactivo)
#   ./app-run.sh status       # Mostrar estado detallado (no interactivo)
#   ./app-run.sh bd-backup    # Crear backup de base de datos (no interactivo)
#   ./app-run.sh bd-restore   # Restaurar base de datos desde backup (no interactivo)
#
# Variables de entorno:
#   APP_TIMEOUT_CHECK=30      # Timeout para verificar servicios (segundos)
#   APP_MAX_ATTEMPTS=20       # Máximo número de intentos de verificación
#   APP_BACKUP_DIR="backups"  # Directorio para backups
#
# Versión: 2.1 - Con funcionalidad de backup
# Fecha: 2025-11-06
# =============================================================================

set -e

# Change to script directory to allow running from anywhere
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Cargar biblioteca compartida
source "$SCRIPT_DIR/app-run_lib.sh"

# Configuración
API_PORT=3001
FRONTEND_PORT=5173
DB_PORT=5432
API_URL="http://localhost:$API_PORT"
FRONTEND_URL="http://localhost:$FRONTEND_PORT"
DB_URL="localhost:$DB_PORT"

# Configuración de timeouts (configurables vía entorno)
TIMEOUT_CHECK=${APP_TIMEOUT_CHECK:-30}
MAX_ATTEMPTS=${APP_MAX_ATTEMPTS:-20}

# Configuración de backup
BACKUP_DIR=${APP_BACKUP_DIR:-"backups"}
BACKUP_FORMAT="dtic_bitacoras_backup_%Y%m%d_%H%M%S.sql"

# Modo de operación
INTERACTIVE_MODE=true
COMMAND=""


# Función para verificar si la aplicación está ejecutándose
check_app_running() {
    log "🔍 Verificando estado de contenedores Docker..."
    # Verificar contenedores Docker
    if docker compose ps 2>/dev/null | grep -q "dtic_bitacoras"; then
        log "✅ Contenedores encontrados ejecutándose"
        return 0
    else
        log "❌ No se encontraron contenedores ejecutándose"
        return 1
    fi
}

# Función para verificar conectividad a PostgreSQL
check_db_connection() {
    log "🔍 Verificando conexión a PostgreSQL..."

    # Método 1: Usar psql si está disponible
    if command -v psql &> /dev/null; then
        log "📡 Intentando conectar a PostgreSQL con psql..."
        if PGPASSWORD=dtic_password psql -h localhost -p $DB_PORT -U dtic_user -d dtic_bitacoras -c "SELECT 1;" &> /dev/null; then
            log "✅ Conexión a PostgreSQL exitosa (psql)"
            return 0
        else
            log "❌ Fallo en conexión a PostgreSQL (psql)"
        fi
    else
        log "⚠️ psql no disponible, intentando método alternativo con curl..."
    fi

    # Método 2: Verificar conectividad usando la API (que internamente usa PostgreSQL)
    log "🌐 Verificando conectividad de BD a través de la API..."
    if curl -s --max-time 5 "$API_URL/health" >/dev/null 2>&1; then
        log "✅ API responde, indicando que PostgreSQL está conectado"
        return 0
    else
        log "❌ API no responde, posible problema con PostgreSQL"
        return 1
    fi
}

# Función para verificar si la API está accesible
check_api_accessible() {
    log "🔍 Verificando accesibilidad de la API..."
    log "🌐 Probando endpoint: $API_URL/health"
    if curl -s --max-time 5 "$API_URL/health" >/dev/null 2>&1; then
        log "✅ API accesible"
        return 0
    else
        log "❌ API no accesible"
        return 1
    fi
}

# Función para verificar si el frontend está accesible
check_frontend_accessible() {
    log "🔍 Verificando accesibilidad del frontend..."
    log "🌐 Probando URL: $FRONTEND_URL"
    if curl -s --max-time 5 "$FRONTEND_URL" >/dev/null 2>&1; then
        log "✅ Frontend accesible"
        return 0
    else
        log "❌ Frontend no accesible"
        return 1
    fi
}

# Función para mostrar estado actual
show_status() {
    echo ""
    echo "📊 Estado Actual de DTIC Bitácoras:"
    echo "=================================="

    if check_app_running; then
        echo -e "🐳 Contenedores: ${GREEN}✅ Ejecutándose${NC}"

        if check_api_accessible; then
            echo -e "🔧 API: ${GREEN}✅ Accesible${NC} (puerto $API_PORT)"
        else
            echo -e "🔧 API: ${RED}❌ No accesible${NC} (puerto $API_PORT)"
        fi

        if check_frontend_accessible; then
            echo -e "🌐 Frontend: ${GREEN}✅ Accesible${NC} (puerto $FRONTEND_PORT)"
        else
            echo -e "🌐 Frontend: ${RED}❌ No accesible${NC} (puerto $FRONTEND_PORT)"
        fi

        if check_db_connection; then
            echo -e "🗄️  Base de Datos: ${GREEN}✅ Conectada${NC} (puerto $DB_PORT)"
        else
            echo -e "🗄️  Base de Datos: ${RED}❌ No conectada${NC} (puerto $DB_PORT)"
        fi
    else
        echo -e "� Contenedores: ${RED}❌ Detenidos${NC}"
        echo -e "🔧 API: ${YELLOW}❓ No verificable${NC}"
        echo -e "🌐 Frontend: ${YELLOW}❓ No verificable${NC}"
        echo -e "🗄️  Base de Datos: ${YELLOW}❓ No verificable${NC}"
    fi
    echo ""
}

# Función para mostrar menú de opciones
show_menu() {
    echo "Opciones disponibles:"
    echo "==================="

    local option_num=1

    if check_app_running; then
        echo -e "${GREEN}${option_num})${NC} 🛑 Detener aplicación"
        ((option_num++))
        echo -e "${GREEN}${option_num})${NC} 🔄 Reiniciar aplicación"
        ((option_num++))
        echo -e "${YELLOW}${option_num})${NC} 💾 Crear backup de BD"
        ((option_num++))
        echo -e "${YELLOW}${option_num})${NC} 🔄 Restaurar BD desde backup"
        ((option_num++))
    else
        echo -e "${GREEN}${option_num})${NC} ▶️  Iniciar aplicación"
        ((option_num++))
        echo -e "${YELLOW}${option_num})${NC} 💾 Crear backup de BD"
        ((option_num++))
        echo -e "${YELLOW}${option_num})${NC} 🔄 Restaurar BD desde backup"
        ((option_num++))
    fi

    echo -e "${BLUE}${option_num})${NC} 📊 Ver estado detallado"
    ((option_num++))
    echo -e "${BLUE}${option_num})${NC} 🚪 Salir"
    echo ""
}

# Función para iniciar aplicación
start_app() {
    log "🚀 Iniciando aplicación DTIC Bitácoras..."

    if check_app_running; then
        warning "La aplicación ya está ejecutándose"
        return 0
    fi

    # Cleanup automático antes de iniciar
    cleanup_resources

    log "🐳 Ejecutando 'docker compose up --build -d'..."
    if docker compose up --build -d; then
        success "Aplicación iniciada"

        # Esperar a que esté lista
        log "⏳ Esperando que los servicios estén listos..."
        sleep 5

        local attempts=0
        while [ $attempts -lt $MAX_ATTEMPTS ]; do
            log "🔄 Intento $((attempts+1))/$MAX_ATTEMPTS de verificación de servicios..."
            if check_api_accessible && check_frontend_accessible && check_db_connection; then
                success "✅ Todos los servicios están listos"
                if [ "$INTERACTIVE_MODE" = false ]; then
                    show_access_urls
                fi
                break
            fi
            sleep 3
            ((attempts++))
        done

        if [ $attempts -eq $MAX_ATTEMPTS ]; then
            warning "⚠️  Algunos servicios pueden no estar completamente listos aún"
            log "📊 Estado final de servicios:"
            check_api_accessible
            check_frontend_accessible
            check_db_connection
        fi
    else
        error "❌ Fallo al iniciar la aplicación"
        log "🔍 Verificando logs de Docker para más detalles..."
        docker compose logs --tail=20
        return 1
    fi
}

# Función para detener aplicación
stop_app() {
    log "🛑 Deteniendo aplicación DTIC Bitácoras..."

    if ! check_app_running; then
        warning "La aplicación no está ejecutándose"
        return 0
    fi

    log "🐳 Ejecutando 'docker compose down'..."
    if docker compose down; then
        success "Aplicación detenida"
        # Cleanup automático después de detener
        cleanup_resources
    else
        error "❌ Fallo al detener la aplicación"
        log "🔍 Verificando estado actual de contenedores..."
        docker compose ps
        return 1
    fi
}

# Función para cleanup de recursos
cleanup_resources() {
    log "🧹 Realizando limpieza automática de recursos..."

    # Limpiar contenedores detenidos
    log "🗑️ Limpiando contenedores detenidos..."
    if docker container prune -f >/dev/null 2>&1; then
        log "✅ Contenedores huérfanos limpiados"
    else
        log "⚠️ No se pudieron limpiar contenedores huérfanos"
    fi

    # Limpiar imágenes no utilizadas (opcional, solo si hay muchas)
    # docker image prune -f >/dev/null 2>&1

    # Limpiar volúmenes huérfanos (con cuidado)
    log "🗂️ Limpiando volúmenes huérfanos..."
    if docker volume prune -f >/dev/null 2>&1; then
        log "✅ Volúmenes huérfanos limpiados"
    else
        log "⚠️ No se pudieron limpiar volúmenes huérfanos"
    fi
}

# Función para crear backup de la base de datos
backup_database() {
    log "💾 Iniciando proceso de backup de base de datos..."

    # Verificar que la aplicación esté ejecutándose
    if ! check_app_running; then
        error "❌ La aplicación no está ejecutándose. Inicia la aplicación antes de hacer backup."
        return 1
    fi

    # Crear directorio de backups si no existe
    log "📁 Verificando directorio de backups: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    if [ ! -d "$BACKUP_DIR" ]; then
        error "❌ No se pudo crear el directorio de backups: $BACKUP_DIR"
        return 1
    fi

    # Generar nombre del archivo de backup con timestamp
    local backup_filename
    backup_filename=$(date +"$BACKUP_FORMAT")
    local backup_path="$BACKUP_DIR/$backup_filename"

    log "📄 Archivo de backup: $backup_path"

    # Verificar conexión a PostgreSQL
    if ! check_db_connection; then
        error "❌ No se puede conectar a la base de datos. Verifica que PostgreSQL esté funcionando."
        return 1
    fi

    # Obtener credenciales de la base de datos desde docker-compose
    local db_host="localhost"
    local db_port=$DB_PORT
    local db_name="dtic_bitacoras"
    local db_user="dtic_user"
    local db_password="dtic_password"

    # Verificar si hay variables de entorno en el archivo .env
    if [ -f "backend/.env" ]; then
        source backend/.env 2>/dev/null || true
    fi

    log "🔐 Conectando a PostgreSQL para crear backup..."
    log "📡 Host: $db_host:$db_port"
    log "🗄️  Base de datos: $db_name"
    log "👤 Usuario: $db_user"

    # Verificar si psql está disponible localmente
    local use_docker_psql=false
    if ! command -v psql &> /dev/null; then
        log "⚠️ psql no está disponible localmente, usando Docker container..."
        use_docker_psql=true
    fi

    # Crear el backup usando pg_dump
    log "⏳ Ejecutando pg_dump..."

    local backup_success=false

    if [ "$use_docker_psql" = true ]; then
        # Usar psql desde el contenedor de PostgreSQL
        log "🐳 Usando PostgreSQL client desde Docker container..."
        
        # Crear el backup dentro del contenedor y copiarlo al host
        local temp_backup_name="temp_backup_$(date +%s).sql"
        if docker exec -e PGPASSWORD="$db_password" dtic_bitacoras_postgres pg_dump -h localhost -p 5432 -U "$db_user" -d "$db_name" -f "/tmp/$temp_backup_name"; then
            log "📁 Copiando backup desde contenedor al host..."
            if docker cp dtic_bitacoras_postgres:/tmp/"$temp_backup_name" "$backup_path"; then
                # Limpiar el archivo temporal del contenedor
                docker exec dtic_bitacoras_postgres rm -f "/tmp/$temp_backup_name"
                backup_success=true
            else
                error "❌ Error al copiar el backup desde el contenedor"
            fi
        else
            error "❌ Error al crear el backup dentro del contenedor"
        fi
    else
        # Usar psql local
        log "💻 Usando PostgreSQL client local..."
        if PGPASSWORD="$db_password" pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -d "$db_name" -f "$backup_path"; then
            backup_success=true
        fi
    fi

    if [ "$backup_success" = true ]; then
        success "✅ Backup creado exitosamente: $backup_path"

        # Verificar que el archivo se creó y tiene contenido
        if [ -f "$backup_path" ] && [ -s "$backup_path" ]; then
            local file_size
            file_size=$(du -h "$backup_path" | cut -f1)
            log "📊 Tamaño del backup: $file_size"

            # Mostrar información adicional del backup
            log "🔍 Verificando integridad del backup..."
            local line_count
            line_count=$(wc -l < "$backup_path")
            log "📋 Líneas en el backup: $line_count"

            if [ $line_count -gt 10 ]; then
                success "✅ Backup verificado correctamente"
            else
                warning "⚠️ El backup parece tener pocas líneas, pero se creó exitosamente"
            fi

            return 0
        else
            error "❌ El archivo de backup se creó pero está vacío o no existe"
            return 1
        fi
    else
        error "❌ Error al crear el backup. Verifica la conectividad y credenciales de la base de datos."
        
        # Limpiar archivo de backup parcial si existe
        if [ -f "$backup_path" ]; then
            rm -f "$backup_path"
            log "🗑️ Archivo de backup parcial eliminado"
        fi
        
        return 1
    fi
}

# Función para restaurar base de datos desde backup
restore_database() {
    log "💾 Iniciando proceso de restauración de base de datos..."

    # Verificar que la aplicación esté ejecutándose
    if ! check_app_running; then
        error "❌ La aplicación no está ejecutándose. Inicia la aplicación antes de restaurar."
        return 1
    fi

    # Ruta del archivo de backup
    local backup_file="backups/dtic_bitacoras_backup_20251107_171026.sql"

    # Verificar que el archivo existe
    if [ ! -f "$backup_file" ]; then
        error "❌ Archivo de backup no encontrado: $backup_file"
        return 1
    fi

    # Verificar conexión a PostgreSQL
    if ! check_db_connection; then
        error "❌ No se puede conectar a la base de datos. Verifica que PostgreSQL esté funcionando."
        return 1
    fi

    # Obtener credenciales de la base de datos
    local db_name="dtic_bitacoras"
    local db_user="dtic_user"
    local db_password="dtic_password"

    log "🔐 Conectando a PostgreSQL para restaurar..."
    log "📄 Archivo de backup: $backup_file"
    log "🗄️  Base de datos: $db_name"
    log "👤 Usuario: $db_user"

    # Copiar archivo de backup al contenedor
    local temp_backup_name="restore_backup.sql"
    log "📁 Copiando archivo de backup al contenedor..."
    if ! docker cp "$backup_file" dtic_bitacoras_postgres:/tmp/"$temp_backup_name"; then
        error "❌ Error al copiar el archivo de backup al contenedor"
        return 1
    fi

    # Preparar base de datos para restauración (drop y recreate)
    log "🗄️ Preparando base de datos para restauración..."
    if ! docker exec -e PGPASSWORD="$db_password" dtic_bitacoras_postgres psql -h localhost -p 5432 -U "$db_user" -d postgres -c "DROP DATABASE IF EXISTS $db_name;"; then
        error "❌ Error al eliminar la base de datos existente"
        # Limpiar archivo temporal
        docker exec dtic_bitacoras_postgres rm -f "/tmp/$temp_backup_name" 2>/dev/null || true
        return 1
    fi

    if ! docker exec -e PGPASSWORD="$db_password" dtic_bitacoras_postgres psql -h localhost -p 5432 -U "$db_user" -d postgres -c "CREATE DATABASE $db_name;"; then
        error "❌ Error al crear la base de datos"
        # Limpiar archivo temporal
        docker exec dtic_bitacoras_postgres rm -f "/tmp/$temp_backup_name" 2>/dev/null || true
        return 1
    fi

    # Ejecutar restauración
    log "⏳ Ejecutando restauración desde backup..."
    if docker exec -e PGPASSWORD="$db_password" dtic_bitacoras_postgres psql -h localhost -p 5432 -U "$db_user" -d "$db_name" -f "/tmp/$temp_backup_name"; then
        success "✅ Restauración completada exitosamente"

        # Verificar que la restauración fue exitosa
        log "🔍 Verificando restauración..."
        if docker exec -e PGPASSWORD="$db_password" dtic_bitacoras_postgres psql -h localhost -p 5432 -U "$db_user" -d "$db_name" -c "SELECT 1;" &>/dev/null; then
            success "✅ Base de datos restaurada y verificada correctamente"
        else
            warning "⚠️ La restauración se completó pero la verificación falló"
        fi

        # Limpiar archivo temporal
        docker exec dtic_bitacoras_postgres rm -f "/tmp/$temp_backup_name"
        return 0
    else
        error "❌ Error durante la restauración"
        # Limpiar archivo temporal
        docker exec dtic_bitacoras_postgres rm -f "/tmp/$temp_backup_name"
        return 1
    fi
}

# Función para reiniciar aplicación
restart_app() {
    log "🔄 Reiniciando aplicación DTIC Bitácoras..."

    if ! check_app_running; then
        warning "La aplicación no está ejecutándose. Iniciándola..."
        start_app
        return $?
    fi

    log "🐳 Ejecutando 'docker compose restart'..."
    if docker compose restart; then
        success "Aplicación reiniciada"

        # Verificar que esté funcionando después del reinicio
        log "⏳ Verificando servicios después del reinicio..."
        sleep 3
        if check_api_accessible && check_frontend_accessible; then
            success "✅ Servicios verificados después del reinicio"
        else
            warning "⚠️  Algunos servicios pueden tardar en estar listos"
            log "📊 Estado de servicios post-reinicio:"
            check_api_accessible
            check_frontend_accessible
        fi
    else
        error "❌ Fallo al reiniciar la aplicación"
        log "🔍 Verificando logs de reinicio..."
        docker compose logs --tail=10
        return 1
    fi
}

# Función para mostrar estado detallado
show_detailed_status() {
    echo ""
    echo "📊 Estado Detallado del Sistema:"
    echo "==============================="

    echo "🐳 Contenedores Docker:"
    docker compose ps
    echo ""

    if check_app_running; then
        echo "🔧 API Health Check:"
        if check_api_accessible; then
            curl -s "$API_URL/health" | jq . 2>/dev/null || curl -s "$API_URL/health"
        else
            echo -e "${RED}❌ API no accesible${NC}"
        fi
        echo ""

        echo "🌐 Frontend Status:"
        if check_frontend_accessible; then
            echo -e "${GREEN}✅ Frontend accesible${NC}"
        else
            echo -e "${RED}❌ Frontend no accesible${NC}"
        fi
        echo ""

        echo "🗄️ Base de Datos:"
        if check_db_connection; then
            echo -e "${GREEN}✅ Conexión exitosa a PostgreSQL${NC}"
            # Mostrar información básica de la BD
            if command -v psql &> /dev/null; then
                echo "Tablas en la base de datos:"
                PGPASSWORD=dtic_password psql -h localhost -p $DB_PORT -U dtic_user -d dtic_bitacoras -c "\dt" 2>/dev/null | head -10
            fi
        else
            echo -e "${RED}❌ No se puede conectar a PostgreSQL${NC}"
        fi
        echo ""
    fi
}

# Función para mostrar URLs de acceso
show_access_urls() {
    echo ""
    echo "🌐 URLs de Acceso:"
    echo "================="

    if check_api_accessible; then
        echo -e "🔧 API: ${GREEN}$API_URL${NC}"
        echo -e "   Health Check: ${GREEN}$API_URL/health${NC}"
    else
        echo -e "🔧 API: ${RED}$API_URL${NC} (no accesible)"
    fi

    if check_frontend_accessible; then
        echo -e "🌐 Frontend: ${GREEN}$FRONTEND_URL${NC}"
    else
        echo -e "🌐 Frontend: ${RED}$FRONTEND_URL${NC} (no accesible)"
    fi

    echo ""
    echo -e "${BLUE}💡 Para acceder a la aplicación, use la URL del Frontend en su navegador${NC}"
}

# Función para procesar parámetros de línea de comandos
parse_command() {
    case "$1" in
        start)
            INTERACTIVE_MODE=false
            COMMAND="start"
            ;;
        stop)
            INTERACTIVE_MODE=false
            COMMAND="stop"
            ;;
        restart)
            INTERACTIVE_MODE=false
            COMMAND="restart"
            ;;
        status)
            INTERACTIVE_MODE=false
            COMMAND="status"
            ;;
        bd-backup)
            INTERACTIVE_MODE=false
            COMMAND="backup"
            ;;
        bd-restore)
            INTERACTIVE_MODE=false
            COMMAND="restore"
            ;;
        *)
            INTERACTIVE_MODE=true
            ;;
    esac
}

# Función principal
main() {
    # Ejecutar configuración inicial solo en la primera ejecución
    if is_first_run; then
        "$SCRIPT_DIR/app-run_deps.sh" initial-setup || exit 1
    fi

    # Procesar parámetros de línea de comandos
    parse_command "$1"

    if [ "$INTERACTIVE_MODE" = false ]; then
        # Modo no interactivo
        case "$COMMAND" in
            start)
                "$SCRIPT_DIR/app-run_deps.sh" check-docker-deps || exit 1
                start_app
                ;;
            stop)
                "$SCRIPT_DIR/app-run_deps.sh" check-docker-deps || exit 1
                stop_app
                ;;
            restart)
                "$SCRIPT_DIR/app-run_deps.sh" check-docker-deps || exit 1
                restart_app
                ;;
            status)
                "$SCRIPT_DIR/app-run_deps.sh" check-docker-deps || exit 1
                show_status
                show_access_urls
                ;;
            backup)
                "$SCRIPT_DIR/app-run_deps.sh" check-docker-deps || exit 1
                backup_database
                ;;
            restore)
                "$SCRIPT_DIR/app-run_deps.sh" check-docker-deps || exit 1
                restore_database
                ;;
        esac
    else
        # Modo interactivo (comportamiento original)
        echo ""
        echo "🚀 DTIC Bitácoras - Gestor Inteligente"
        echo "====================================="
        echo ""

        # Mostrar estado inicial
        show_status

        # Bucle principal
        while true; do
            show_menu

            # Determinar rango de opciones válido
            local max_option
            if check_app_running; then
                max_option=6  # 1:detener, 2:reiniciar, 3:backup, 4:restore, 5:estado, 6:salir
                read -p "Seleccione una opción (1-6): " choice
            else
                max_option=5  # 1:iniciar, 2:backup, 3:restore, 4:estado, 5:salir
                read -p "Seleccione una opción (1-5): " choice
            fi

            case $choice in
                1)
                    if check_app_running; then
                        stop_app
                    else
                        start_app
                    fi
                    echo ""
                    read -p "Presione Enter para continuar..."
                    ;;
                2)
                    if check_app_running; then
                        restart_app
                    else
                        backup_database
                    fi
                    echo ""
                    read -p "Presione Enter para continuar..."
                    ;;
                3)
                    if check_app_running; then
                        backup_database
                    else
                        restore_database
                    fi
                    echo ""
                    read -p "Presione Enter para continuar..."
                    ;;
                4)
                    if check_app_running; then
                        restore_database
                    else
                        show_detailed_status
                    fi
                    echo ""
                    read -p "Presione Enter para continuar..."
                    ;;
                5)
                    if check_app_running; then
                        show_detailed_status
                    else
                        echo ""
                        log "¡Hasta luego!"
                        break
                    fi
                    echo ""
                    read -p "Presione Enter para continuar..."
                    ;;
                6)
                    if check_app_running; then
                        echo ""
                        log "¡Hasta luego!"
                        break
                    else
                        error "Opción inválida."
                        sleep 2
                    fi
                    ;;
                *)
                    error "Opción inválida."
                    sleep 2
                    ;;
            esac

            # Mostrar estado actualizado y URLs después de cada acción
            show_status
            show_access_urls
        done
    fi
}

# Verificar dependencias antes de continuar
"$SCRIPT_DIR/app-run_deps.sh" check-docker-deps || exit 1

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose.yml" ]; then
    error "No se encuentra docker-compose.yml. Asegúrese de ejecutar este script desde el directorio _app-bitacoras"
    exit 1
fi

# Ejecutar función principal con parámetros
main "$@"