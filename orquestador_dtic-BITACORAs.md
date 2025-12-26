---
title: "dtic-BITACORAs - Orquestador Especializado"
version: "v1.7.0"
author: "Sistema OIS"
description: "Orquestador especializado para el proyecto dtic-BITACORAs, una aplicación web (React/Node.js/PostgreSQL/Docker) para gestión de bitácoras."
language: "es"
communication_policy: "spanish_only"
last_updated: "2025-11-19"
framework_type: "Web Application (React/Node.js/PostgreSQL/Docker)"
extensions: []
  # Placeholder for extension metadata
  # - name: "example_extension"
  #   version: "1.0.0"
  #   description: "Description of extension"
---

# dtic-BITACORAs - Orquestador Especializado

Orquestador especializado para el proyecto dtic-BITACORAs, una aplicación web (React/Node.js/PostgreSQL/Docker) para gestión de bitácoras.

## Índice de Orquestación

### Catálogo Estructurado

```yaml
# CONFIGURACIÓN AUTOMÁTICA DE ORQUESTACIÓN
orquestadores:
  onboarding_orchestrator:
    id: "OIS-ONBOARD-001"
    nombre: "Orquestador de Inicio de Proyecto DTIC-BITACORAs"
    categoria: "onboarding"
    prioridad: 1
    palabras_clave: ["proyecto nuevo", "iniciar proyecto", "onboarding", "verificar proyecto", "dtic-BITACORAs"]
    patrones_matching: ["verifica si esta todo listo", "crear orquestador especifico", "proyecto dtic-BITACORAs", "vamos a trabajar con el proyecto"]
    uso_recomendado: "Para la configuración inicial del proyecto DTIC-BITACORAs y la generación de su orquestador dedicado."
    descripcion: "Orquestador especializado en la validación y preparación del proyecto DTIC-BITACORAs, incluyendo la generación de su plantilla específica."

  infrastructure_orchestrator:
    id: "OIS-INFRA-001"
    nombre: "Orquestador de Infraestructura y Entorno DTIC-BITACORAs"
    categoria: "infraestructura"
    prioridad: 2
    palabras_clave: ["directorio", "repositorio", "montar", "desmontar", "git", "entorno", "ruta", "commit", "dtic-BITACORAs"]
    patrones_matching: ["montar directorio", "ruta del proyecto", "gestionar repositorio", "commit git", "configurar entorno de trabajo", "proyecto dtic-BITACORAs"]
    uso_recomendado: "Manejar tareas relacionadas con el sistema de archivos, directorios de trabajo, y operaciones de Git/repositorio para DTIC-BITACORAs."
    descripcion: "Orquestador especializado en la gestión del entorno de trabajo del proyecto DTIC-BITACORAs, asegurando que la ruta del proyecto y el estado del repositorio sean correctos para la ejecución de tareas."

  development_orchestrator:
    id: "OIS-DEV-001"
    nombre: "Orquestador de Desarrollo DTIC-BITACORAs"
    categoria: "desarrollo"
    prioridad: 2
    palabras_clave: ["desarrollo", "frontend", "backend", "implementar", "codigo", "react", "node.js", "postgresql", "docker", "dtic-BITACORAs"]
    patrones_matching: ["desarrollar", "implementar", "crear funcionalidad", "desarrollo frontend", "desarrollo backend", "proyecto dtic-BITACORAs"]
    uso_recomendado: "Coordinar tareas de desarrollo frontend/backend para el proyecto DTIC-BITACORAs."
    descripcion: "Orquestador para desarrollo de software en DTIC-BITACORAs con integración SCORRIG."

# CLASIFICACIÓN AUTOMÁTICA
clasificacion:
  categorias:
   general: ["coordinador"]
   switching: ["switcher"]
   versionado: ["version"]
   desarrollo: ["frontend", "backend"]
   documentacion: ["docs"]
   debugging: ["error"]
   optimizacion: ["performance"]
   onboarding: ["onboarding"]
   infraestructura: ["infraestructura"]

  priority_rules:
    - categoria: "switching"
      prioridad_alta: true
    - categoria: "general"
      priority_base: true
    - categoria: "onboarding"
      prioridad_alta: true

  match_algorithm:
    exact_match: true
    fuzzy_match: true
    weight_by_priority: true
    consider_categoria: true
```

## Lógica de Selección

### Algoritmo de Clasificación

```javascript
// Algoritmo de clasificación para dtic-BITACORAs
function selectOrchestrator(userPrompt) {
    const promptLower = userPrompt.toLowerCase();
    let bestOrchestrator = orchestrators.onboarding_orchestrator;
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
- Evaluar la solicitud completa y contexto del proyecto DTIC-BITACORAs.
- Identificar dependencias y requisitos previos.
- Registrar análisis en `/home/rmonla/GitHub/dtic-BITACORAs/_tareasTerminadas/` para trazabilidad.

### Fase 2: Planificación
- Generar plan detallado basado en orquestador seleccionado.
- Incluir bucle de confirmación: Presentar plan al usuario y obtener aprobación.
- Ajustar plan según feedback, repitiendo hasta validación.

### Fase 3: Implementación
- Ejecutar acciones automatizadas según el plan aprobado.
- Integrar con herramientas (Git, tests, etc.) para ejecución eficiente.
- Monitorear progreso y registrar estados en `/home/rmonla/GitHub/dtic-BITACORAs/_estados/`.

### Fase 4: Validación
- Verificar resultados contra criterios definidos.
- Ejecutar tests y validaciones automáticas/manuales.
- Actualizar métricas y activar SCORRIG para optimización futura.
- Commit final con mensaje estructurado.

## Ejemplos de Uso

### Desarrollo Frontend en DTIC-BITACORAs
"Implementar un nuevo componente React para gestión de bitácoras en DTIC-BITACORAs"

**Análisis:** Solicitud de desarrollo frontend para componente de gestión de bitácoras.
**Planificación:** Crear componente React con hooks, integrar con API backend, añadir validaciones.
**Implementación:** Desarrollar componente, conectar a store, probar funcionalidad.
**Validación:** Verificar renderizado correcto, pruebas unitarias, integración exitosa.

### Configuración de Infraestructura
"Configurar entorno Docker para DTIC-BITACORAs"

**Análisis:** Necesidad de setup de contenedores para desarrollo local.
**Planificación:** Crear docker-compose.yml, configurar servicios PostgreSQL/Node.js/React.
**Implementación:** Ejecutar docker-compose up, verificar conexiones.
**Validación:** Probar aplicación completa en contenedores, validar persistencia de datos.

### Onboarding de Proyecto
"Iniciar trabajo en proyecto DTIC-BITACORAs"

**Análisis:** Verificación de estado del proyecto y preparación del entorno.
**Planificación:** Montar directorio, verificar repositorio Git, confirmar configuración.
**Implementación:** Ejecutar scripts de setup, validar dependencias.
**Validación:** Confirmar aplicación funcional, registrar estado inicial.

## Referencias
- **Template Base**: Ver `orchestrator-template.md` para estructura base.
- **Configuración OIS**: Ubicadas en `a-ois_core/a-ois_config.json` para orquestadores disponibles.
- **Prompts DTIC-BITACORAs**: `prompts_app_dtic-BITACORAs.md` integrado en todas las fases para contexto específico.

## Notas Adicionales
- **Idioma**: Comunicación exclusivamente en español para el proyecto DTIC-BITACORAs.
- **Automatización**: Integración completa con SCORRIG para optimización de procesos.
- **Escalabilidad**: Diseñado para crecimiento del sistema de gestión de bitácoras.

---

## Política de Comunicación - REQUISITO CRÍTICO

**🚨 REQUISITO OBLIGATORIO: TODA LA COMUNICACIÓN DEBE SER EN ESPAÑOL**

Esta política es un **requisito crítico y no negociable** para todas las interacciones con el usuario en el proyecto DTIC-BITACORAs.

### 📋 Requisitos Obligatorios

#### **Comunicación con el Usuario**
- ✅ **TODAS** las respuestas al usuario deben estar **exclusivamente en español**
- ✅ **TODAS** las explicaciones técnicas deben estar **en español**
- ✅ **TODAS** las documentaciones deben estar **en español**

#### **Contenido Prohibido**
- ❌ **NINGUNA** respuesta en inglés
- ❌ **NINGUNA** documentación en inglés

### 🔧 Procesamiento Interno (Permitido en Inglés)
**ÚNICAMENTE** se permite inglés para código fuente y configuraciones técnicas.

### ⚖️ Reglas de Ejecución
#### **Validación Automática**
- El sistema debe validar que todas las respuestas estén en español
- Cualquier respuesta en inglés debe ser rechazada

---

## Historial de Versiones
- **Versión v1.7.0:** 2025-11-19 - Especialización completa para proyecto DTIC-BITACORAs con orquestadores adaptados.
- **Versión v1.6.0:** 2025-11-14 - Integración de templates específicos de DTIC-BITACORAs.
- **Versión v1.5.0:** 2025-11-14 - Implementación de política de comunicación en español.