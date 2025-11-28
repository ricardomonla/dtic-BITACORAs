#!/bin/bash

# =============================================================================
# DTIC Bitácoras - Biblioteca de Funciones Compartidas
# =============================================================================
#
# Biblioteca de funciones reutilizables para scripts de gestión de aplicación
#
# Versión: 1.0
# Fecha: 2025-11-28
# =============================================================================

# Colores para salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Archivo para recordar si ya se ejecutó la configuración inicial
SETUP_MARKER=".dtic_setup_done"

# Funciones de logging
log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Función para verificar si es la primera ejecución
is_first_run() {
    [ ! -f "$SETUP_MARKER" ]
}

# Función para marcar que la configuración inicial se completó
mark_setup_complete() {
    touch "$SETUP_MARKER"
    log "📝 Configuración inicial completada"
}