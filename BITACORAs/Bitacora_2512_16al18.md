# 📊 Bitácora SERVIDORES
**Responsable:** Lic. Ricardo MONLA  
**Área:** Departamento Servidores y Sistemas de Altas Prestaciones  
**Oficina:** Dirección de Tecnologías de la Información y la Comunicación (DTIC)  
**Institución:** Universidad Tecnológica Nacional – Facultad Regional La Rioja  

---

## ⏱️ Cronología de Actividades

### 📅 16/12/2025
| Hora        | Recurso         | Detalle |
|-------------|-----------------|---------|
| 16:00_16:34 | **dtic_DIGI** | Generación y publicación de planilla de control para salas de Zoom. Se compartió el recurso con el agente C. Gatica para facilitar la consulta unificada de reuniones y sus respectivos identificadores (IDs). <ul><li>Recurso: [Salas Zoom - UTNLR](https://docs.google.com/spreadsheets/d/e/2PACX-1vRokHqxu8hHkMDf8WDb8hUHCS5GuSbVoqtHC60CeF42Wdixxczb56NI8aSz7aLZ6cuiedXxW6NpTsVx/pubhtml?gid=1528208013&single=true)</li></ul>|
| 16:34_20:35 | **dtic_TESTServicios** | Desarrollo e implementación de script de automatización para validación de servicios del sistema TITULOS. La herramienta permite la verificación remota centralizada de los protocolos FTP y SMTP, así como la ejecución de pruebas de envío de correo desde la cuenta institucional `titulos@frlr.utn.edu.ar`.|
| 20:35_21:00 | **dtic_BITACORAs** | Registro, actualización y cierre de actividades diarias en el sistema de bitácoras institucionales.|

### 📅 17/12/2025
| Hora        | Recurso         | Detalle |
|-------------|-----------------|---------|
| 16:00_17:15 | **dtic_UPDATEs** | Actualización del Sistema Operativo en los siguientes recursos: <ul><li>16:27 - **srvv_SITIO**</li> <li>16:30 - **srvv_SITIO0**</li> <li>16:33 - **srvv_DTIC**</li><li>16:36 - **srvv_DOCs**</li><li>16:38 - **srvv_DNS**</li><li>16:57 - **srvv_KOHA**</li><li>17:10 - **srvv_DATA**</li><li>17:15 - **srvv_SITIO2**</li></ul> |
| 16:40_16:56 | **srvv_KOHA** |<ul><li>16:40 - Intento de respaldo automático detenido tras detectar cambio de versión mayor (v24 a v25). Se decide priorizar un backup completo de la VM antes de proceder.</li> <li>16:44 - Ejecución exitosa de backup de la VM.</li> <li>16:52 - Ejecución de la actualización del aplicativo Koha.</li> <li>16:56 - Notificación a J. Sánchez sobre la finalización del cambio de versión.</li></ul> |
| 17:21_18:00 | **dtic_BKPs** | Ejecución de copias de seguridad vespertinas desde la consola web de Proxmox: <ul><li>17:26_17:32 - **srvv_SITIO**</li> <li>17:32_17:38 - **srvv_SITIO0**</li> <li>17:39_17:48 - **srvv_DTIC**</li><li>17:48_17:52 - **srvv_DOCs**</li><li>17:52_17:53 - **srvv_DNS**</li><li>17:53_17:58 - **srvv_DATA**</li><li>17:58_17:59 - **srvv_SITIO2**</li><li>17:59_18:00 - **srvv_UPTIME**</li></ul> |

### 📅 18/12/2025
| Hora        | Recurso         | Detalle |
|-------------|-----------------|---------|
| 02:28_03:11 | **dtic_BKPs** | Ejecución de copias de seguridad de madrugada desde la consola web de Proxmox: <ul><li>02:28_02:28 - **srvv_FENIX**</li><li>02:31_02:43 - **pcv_DASU2**</li><li>02:45_02:56 - **pcv_DASU3**</li><li>02:56_03:11 - **pcv_SERVIIO**</li></ul> |
| 03:10_22:11 | **srv_NS8** | Ejecución del script `dtic-BKPs_app.rb v5.5.1`. El proceso abarcó el empaquetado, compresión y sincronización diferida de copias de seguridad tanto en almacenamiento local como en la nube, garantizando la redundancia de datos críticos. |

---

## ✅ Conclusión de la Semana
La semana se caracterizó por una fuerte carga de mantenimiento preventivo y optimización de infraestructura. Se completaron tres hitos principales:
1.  **Gestión Operativa:** Sistematización de salas Zoom y automatización del testeo de servicios para Títulos.
2.  **Actualización de Infraestructura:** Update masivo de sistemas operativos y migración exitosa de Koha (v24 a v25).
3.  **Integridad de Datos:** Ejecución de un ciclo intensivo de respaldos que culminó el día 18 con la sincronización en la nube mediante el script `dtic-BKPs_app.rb`, asegurando la disponibilidad y redundancia de la información institucional.

---

## 📊 Resumen por Recurso - 📅 16/12/2025 al 18/12/2025

| Recurso | Avance principal |
| --- | --- |
| **dtic_DIGI** | Centralización y difusión de la información de acceso a salas Zoom. |
| **dtic_TESTServicios** | Implementación de script de testeo unificado para servicios FTP y SMTP. |
| **dtic_UPDATEs** | Actualización general de sistemas operativos en servidores productivos. |
| **srvv_KOHA** | Actualización exitosa del aplicativo de la versión 24 a la 25. |
| **dtic_BKPs** | Ejecución completa de snapshots y copias en Proxmox (vespertinas y madrugada). |
| **srv_NS8** | Procesamiento y sincronización cloud de backups mediante script automatizado. |
| **dtic_BITACORAs** | Consolidación documental de las tareas diarias. |

---

## 📌 Pendientes o Próximos pasos
* Verificar en el log del script `dtic-BKPs_app.rb` que todos los paquetes hayan subido correctamente a la nube.
* Monitorear la estabilidad de Koha v25 durante la primera semana de uso intensivo.
* Documentar los cambios realizados en el script de testeo de Títulos.

---

✍️ *Última edición: 18/12/2025 22:30*