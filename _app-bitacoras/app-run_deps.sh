#!/bin/bash

# =============================================================================
# DTIC Bitácoras - Gestión de Dependencias
# =============================================================================
#
# Script modular para gestión de dependencias del sistema
# Actúa como API: recibe argumentos CLI y retorna códigos de salida
#
# Uso:
#   ./app-run_deps.sh check-host-deps    # Verifica dependencias del host
#   ./app-run_deps.sh install-host-deps  # Instala dependencias del host
#   ./app-run_deps.sh check-docker-deps  # Verifica dependencias Docker
#   ./app-run_deps.sh initial-setup      # Ejecuta configuración inicial
#
# Códigos de salida:
#   0: Éxito
#   1: Fallo
#
# Versión: 1.0
# Fecha: 2025-11-28
# =============================================================================

# Cargar biblioteca compartida
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/app-run_lib.sh"

# Dependencias del host con sus comandos de instalación por sistema operativo
declare -A HOST_DEPENDENCIES=(
    [curl]="Utilizado para verificar conectividad de servicios"
    [jq]="Utilizado para formatear respuestas JSON (opcional)"
)

declare -A INSTALL_COMMANDS_LINUX=(
    [curl]="apt-get install -y curl"
    [jq]="apt-get install -y jq"
)

declare -A INSTALL_COMMANDS_MACOS=(
    [curl]="brew install curl"
    [jq]="brew install jq"
)

# Función para obtener el gestor de paquetes del sistema
get_package_manager() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            echo "apt-get"
        elif command -v yum &> /dev/null; then
            echo "yum"
        elif command -v dnf &> /dev/null; then
            echo "dnf"
        else
            echo "none"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            echo "brew"
        else
            echo "none"
        fi
    else
        echo "unsupported"
    fi
}

# Función para verificar dependencias del host
check_host_dependencies() {
    log "🔍 Verificando dependencias del sistema host..."
    local missing_deps=()

    for dep in "${!HOST_DEPENDENCIES[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -eq 0 ]; then
        log "✅ Dependencias del host verificadas correctamente"
        return 0
    else
        log "⚠️ Dependencias faltantes detectadas: ${missing_deps[*]}"
        return 1
    fi
}

# Función para instalar dependencias automáticamente
install_host_dependencies() {
    log "🛠️ Instalando dependencias del sistema host..."
    local package_manager=$(get_package_manager)

    case "$package_manager" in
        "apt-get"|"yum"|"dnf")
            sudo "$package_manager" update
            ;;
        "brew")
            # brew no necesita update para install
            ;;
        "none")
            error "❌ No se encontró un gestor de paquetes compatible"
            return 1
            ;;
        "unsupported")
            error "❌ Sistema operativo no soportado para instalación automática"
            return 1
            ;;
    esac

    for dep in "${!HOST_DEPENDENCIES[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log "📦 Instalando $dep..."

            case "$package_manager" in
                "apt-get")
                    sudo apt-get install -y "$dep"
                    ;;
                "yum")
                    sudo yum install -y "$dep"
                    ;;
                "dnf")
                    sudo dnf install -y "$dep"
                    ;;
                "brew")
                    brew install "$dep"
                    ;;
                *)
                    error "❌ No se puede instalar $dep: $package_manager no soportado"
                    continue
                    ;;
            esac

            if command -v "$dep" &> /dev/null; then
                success "✅ $dep instalado correctamente"
            else
                error "❌ Error al instalar $dep"
            fi
        fi
    done

    return 0
}

# Función para verificar dependencias Docker
check_docker_dependencies() {
    log "🔍 Verificando dependencias del sistema..."
    local missing_deps=()

    if ! command -v docker &> /dev/null; then
        missing_deps+=("docker")
    fi

    if ! command -v docker &> /dev/null || ! docker compose version &> /dev/null; then
        missing_deps+=("docker-compose")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        error "Dependencias faltantes: ${missing_deps[*]}"
        error "Por favor instala las dependencias requeridas antes de continuar"
        return 1
    fi

    # Verificar que Docker esté ejecutándose
    log "🔍 Verificando que Docker daemon esté ejecutándose..."
    if ! docker info &> /dev/null; then
        error "Docker daemon no está ejecutándose"
        error "Por favor inicia Docker y vuelve a intentar"
        return 1
    fi

    # Verificar que docker-compose funcione
    log "🔍 Verificando funcionalidad de docker-compose..."
    if ! docker compose version &> /dev/null; then
        error "docker-compose no funciona correctamente"
        return 1
    fi

    log "✅ Todas las dependencias verificadas correctamente"
    return 0
}

# Función para ejecutar configuración inicial
run_initial_setup() {
    echo ""
    echo "🚀 Configuración Inicial de DTIC Bitácoras"
    echo "========================================="
    echo ""
    log "🔧 Esta es la primera vez que ejecutas el script en este sistema"
    log "🛠️ Se verificarán e instalarán las dependencias necesarias"
    echo ""

    # Verificar dependencias del host
    if ! check_host_dependencies; then
        echo ""
        warning "⚠️ Se detectaron dependencias faltantes en el sistema host:"
        echo ""
        echo "Dependencias que se pueden instalar automáticamente:"
        for dep in "${!HOST_DEPENDENCIES[@]}"; do
            echo "  • $dep - ${HOST_DEPENDENCIES[$dep]}"
        done
        echo ""
        echo "Sistemas soportados:"
        echo "  • Linux (Ubuntu/Debian, CentOS/RHEL, Fedora)"
        echo "  • macOS (con Homebrew)"
        echo ""

        # En modo API, siempre intentar instalar automáticamente
        log "Ejecutando instalación automática de dependencias..."
        if install_host_dependencies; then
            success "✅ Dependencias instaladas correctamente"
        else
            error "❌ Error al instalar algunas dependencias"
            echo ""
            echo "Puedes instalar manualmente en:"
            echo "  • curl: https://curl.se/download.html"
            echo "  • jq: https://stedolan.github.io/jq/download/"
            return 1
        fi
    else
        log "✅ Todas las dependencias ya están instaladas"
    fi

    # Marcar configuración como completada
    mark_setup_complete
    echo ""
    success "🎉 Configuración inicial completada"
    echo ""
    sleep 2
    return 0
}

# Procesar argumentos CLI
case "$1" in
    check-host-deps)
        check_host_dependencies
        ;;
    install-host-deps)
        install_host_dependencies
        ;;
    check-docker-deps)
        check_docker_dependencies
        ;;
    initial-setup)
        run_initial_setup
        ;;
    *)
        error "Uso: $0 {check-host-deps|install-host-deps|check-docker-deps|initial-setup}"
        exit 1
        ;;
esac