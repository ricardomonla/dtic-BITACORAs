Refactor the shell script _app-bitacoras/app-run.sh to improve modularity and maintainability.

    Modularization: Break down the script into task-specific files. Specifically, extract dependency management into a separate file named app-run_deps.sh.

    Inter-script Communication: Ensure sub-scripts function like an API: receiving strict CLI arguments and returning structured output or exit codes to the main script.

    Standardization: Create a shared library of reusable functions to optimize code across all scripts (Apply DRY principles).