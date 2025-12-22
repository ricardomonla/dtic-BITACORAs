# 📊 Bitácora SERVIDORES
**Responsable:** Lic. Ricardo MONLA  
**Área:** Departamento Servidores y Sistemas de Altas Prestaciones  
**Oficina:** Dirección de Tecnologías de la Información y la Comunicación (DTIC)  
**Institución:** Universidad Tecnológica Nacional – Facultad Regional La Rioja  

---

## ⏱️ Cronología de Actividades

### 📅 16/12/2025
| Hora        | Recurso         | Detalle |
|--------------|----------------|----------|
| 16:00_16:34 | **dtic_DIGI** | Generación y publicación de planilla de control para salas de Zoom. Se compartió el recurso con el agente C. Gatica para facilitar la consulta unificada de reuniones y sus respectivos identificadores (IDs). <ul><li>Recurso: [Salas Zoom - UTNLR](https://docs.google.com/spreadsheets/d/e/2PACX-1vRokHqxu8hHkMDf8WDb8hUHCS5GuSbVoqtHC60CeF42Wdixxczb56NI8aSz7aLZ6cuiedXxW6NpTsVx/pubhtml?gid=1528208013&single=true)</li></ul>|
| 16:34_20:35 | **dtic_TESTServicios** | Desarrollo e implementación de script de automatización para validación de servicios del sistema TITULOS. La herramienta permite la verificación remota centralizada de los protocolos FTP y SMTP, así como la ejecución de pruebas de envío de correo desde la cuenta institucional `titulos@frlr.utn.edu.ar`.|
| 20:35_21:00 | **dtic_BITACORAs** | Registro, actualización y cierre de actividades diarias en el sistema de bitácoras institucionales.|

### 📅 17/12/2025
| Hora        | Recurso         | Detalle |
|--------------|----------------|----------|
| 16:00_17:15 | **dtic_UPDATEs** | Se actualiza Sistema Operativo de los siguientes recursos: <ul><li>16:27 - **srvv_SITIO**</li> <li>16:30 - **srvv_SITIO0**</li> <li>16:33 - **srvv_DTIC**</li><li>16:36 - **srvv_DOCs**</li><li>16:38 - **srvv_DNS**</li><li>16:57 - **srvv_KOHA**</li><li>17:10 - **srvv_DATA**</li><li>17:15 - **srvv_SITIO2**</li></ul> |
| 16:40_16:56 | **srvv_KOHA** |<ul><li>16:40 - Se intenta hacer backup pero indica que se cambiaría desde la version de koha de la 24 a la 25 y esto como es un cambio de gran importancia se decide primero hacer backup de toda la VM y luego hacer el cambio de version. </li> <li>16:44 - Se realizó backup de VM sin problemas</li> <li>16:52 - Se realiza actualizacion de aplicativo Koha</li> <li>16:56 - Se informa a JSANCHEZ del cambio de version de Koha</li></ul> |
| 17:21_17:15 | **dtic_BKPs** | Desde la consola web de proxmos se realiza backup de los siguientes recursos: <ul><li>17:26_17:32 - **srvv_SITIO**</li> <li>17:32_17:38  - **srvv_SITIO0**</li> <li>17:39_17:48 - **srvv_DTIC**</li><li>17:48_17:52 - **srvv_DOCs**</li><li>17:52_17:53 - **srvv_DNS**</li><li>17:53_17:58 - **srvv_DATA**</li><li>17:58_17:59 - **srvv_SITIO2**</li><li>17:59_18:00 - **srvv_UPTIME**</li><li>02:28_02:28 - **srvv_FENIX**</li><li>02:31_02:43 - **pcv_DASU2**</li><li>02:45_02:56 - **pcv_DASU3**</li><li>02:56_03:11 - **pcv_SERVIIO**</li></ul> |
---

## ✅ Conclusión de la Semana
Durante la jornada se priorizó la optimización de procesos de monitoreo y gestión operativa. Se sistematizó la visualización de la disponibilidad de salas de videoconferencia para mejorar la coordinación interna con el área administrativa. En el plano técnico, se logró un avance significativo en la automatización de mantenimiento mediante la implementación de un script de diagnóstico unificado; esto permite validar la integridad de los servicios críticos (FTP/SMTP) del departamento de Títulos de manera remota y eficiente, reduciendo tiempos de comprobación manual.

---

## 📊 Resumen por Recurso - 📅 16/12/2025

| Recurso | Avance principal |
| --- | --- |
| **dtic_DIGI** | Centralización y difusión de la información de acceso a salas Zoom. |
| **dtic_TESTServicios** | Implementación de script de testeo unificado para servicios FTP y SMTP (Títulos). |
| **dtic_BITACORAs** | Consolidación documental de las tareas del día. |

---

## 📌 Pendientes o Próximos pasos
* Verificar la correcta recepción y accesibilidad de la planilla de Zoom por parte del usuario destinatario.
* Documentar los parámetros de ejecución y ubicación del script de testeo en el repositorio correspondiente.
* Programar una prueba de estrés o ejecución cronometrada del script de validación de Títulos para asegurar estabilidad.

---

✍️ *Última edición: 16/12/2025 21:00*


---
