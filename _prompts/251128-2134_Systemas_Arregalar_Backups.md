# Prompt para Arreglar el Sistema de Restauración de Backups

### Versión 1: Español (Explicativa)

**Prompt:**
> "Actúa como un desarrollador Full Stack experto. Tu objetivo es **arreglar** (no planificar) la funcionalidad de 'Restauración de Backups' en el módulo del sistema.
>
> **Instrucciones de ejecución:**
> 1.  **Diagnóstico:** Ejecuta pruebas inmediatas enviando peticiones a los endpoints relevantes usando `curl` para simular tanto la petición del frontend como la respuesta del backend.
> 2.  **Análisis:** Lee los errores devueltos por la consola/logs.
> 3.  **Corrección:** Modifica el código necesario para solucionar el error raíz.
> 4.  **Iteración (Recursividad):** Si la prueba falla, repite el proceso de análisis y corrección automáticamente. No pidas permiso, sigue intentando hasta que el `curl` devuelva un estado de éxito (200 OK) y la restauración se complete."

---

### Versión 2: Inglés (Optimizada para la IA)

**Prompt:**
> **ROLE:** Senior Full Stack Engineer.
> **TASK:** DEBUG and FIX the broken 'Backup Restore' feature in the system module immediately.
>
> **CONSTRAINTS:**
> - **DO NOT** generate a plan or a list of suggestions. Write the actual code and terminal commands.
> - **GOAL:** A fully functional restoration process.
>
> **EXECUTION LOOP:**
> 1.  **Test:** Use `curl` to hit the backend API endpoints and simulate frontend triggers.
> 2.  **Analyze:** Identify the failure point (HTTP 500, timeouts, logic errors).
> 3.  **Patch:** Rewrite the specific code blocks causing the issue.
> 4.  **Verify:** Re-run the `curl` test.
> 5.  **Recursion:** Repeat steps 2-4 continuously until the test passes with a success response.
>
> Start by running the diagnostic `curl` commands now.

---