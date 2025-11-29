### Versión 1: Español (Para tu entendimiento)

Esta versión es detallada y estética para que veas la lógica detrás de la petición.

**Prompt:**

> **Rol:** Actúa como un Arquitecto de Software experto en documentación técnica.
>
> **Objetivo:** Generar documentación automática para los módulos del sistema actual en la carpeta `_docs`.
>
> **Instrucciones:**
>
> 1.  **Análisis:** Escanea la estructura del proyecto para identificar los módulos funcionales principales. Utiliza principalmente el código fuente (vistas, lógica de negocio, rutas) como fuente de verdad. Usa el `README` u otros documentos solo como contexto secundario.
> 2.  **Generación:** Para cada módulo identificado, crea un archivo `.md` dentro del directorio `_docs`.
> 3.  **Formato:** Cada archivo debe seguir estrictamente esta estructura:
>       * **Título:** Nombre del módulo (H1).
>       * **Resumen:** Breve descripción de su propósito (basado en el código analizado).
>       * **Funcionalidades:** Lista de *bullet points* con las capacidades clave detectadas en el código.
>       * **Dependencias:** Explicación de cómo este módulo interactúa con otros (importaciones, llamadas a API, enlaces).
>       * **Propuestas de Mejora:** Sugerencias técnicas (refactorización, seguridad, rendimiento) basadas en el análisis del código actual.

-----

### Versión 2: Inglés (Optimizada para la IA)

Esta es la versión "cruda" y directa ("Raw Prompt"). Al estar en inglés y ser imperativa, las IAs de código (como Copilot, Cursor, o ChatGPT en modo código) suelen procesarla mejor y con menos alucinaciones. Copia y pega esto.

**Prompt:**

```text
Role: Technical Documentation Specialist.

Task: Analyze the current project structure/source code to identify distinct functional modules and generate documentation for each in the "_docs" directory.

Input Priority:
1. Source Code (Views, Logic, Controllers/Components) - Primary source of truth.
2. README/Existing docs - Secondary context.

Output Requirements:
For each identified module, create a separate Markdown (.md) file inside "_docs" with the following specific structure:

# [Module Name]

## Description
Brief overview of what the module does based on code analysis.

## Key Features
- List of specific functionalities derived from the logic/UI.

## Module Interrelationships
- Analysis of imports, API calls, or routing links to other system modules.

## Improvement Proposals
- Technical suggestions for code quality, architecture, or performance improvements based on the observed code.
```