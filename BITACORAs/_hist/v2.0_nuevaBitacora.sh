#!/bin/bash
# ============================================================
#  nuevaBitacora.sh - Generador de bitácora SEMANAL (Markdown)
#  Estilo: DTIC - UTN La Rioja (Lic. Ricardo MONLA)
#  ------------------------------------------------------------
#  Uso: ./nuevaBitacora.sh [dia_inicio] [dia_fin]
#  Ejemplo: ./nuevaBitacora.sh 16 20
# ============================================================

# 1. Configuración de Fechas
YEAR_SHORT=$(date +"%y")
YEAR_FULL=$(date +"%Y")
MONTH=$(date +"%m")
MONTH_NAME=$(date +"%B") # Nombre del mes (ej: diciembre)

# Verificar si se pasaron argumentos, si no, pedir input interactivo
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "--- Configuración de la Nueva Bitácora Semanal ---"
    read -p "Ingresa el día de INICIO (ej. 16): " DAY_START
    read -p "Ingresa el día de FIN (ej. 20): " DAY_END
else
    DAY_START=$1
    DAY_END=$2
fi

# Formatear nombre de archivo: Bitacora_AAMM_DDalDD.md
FILE_NAME="Bitacora_${YEAR_SHORT}${MONTH}_${DAY_START}al${DAY_END}.md"

# Rango de fechas legible para el título
RANGO_FECHAS="${DAY_START}/${MONTH}/${YEAR_FULL} al ${DAY_END}/${MONTH}/${YEAR_FULL}"

echo "📘 Generando plantilla semanal: $FILE_NAME ..."

# 2. Generación del Contenido
cat > "$FILE_NAME" <<EOF
**Rol:** Eres un asistente administrativo y técnico experto de la DTIC.
**Tarea:** Corrige, completa y formatea la siguiente bitácora semanal del periodo **${RANGO_FECHAS}**.
**Instrucciones específicas:**
1. **Ortografía y Gramática:** Revisa todo el texto, manteniendo un tono técnico-administrativo profesional.
2. **Cronología:** Verifica que los bloques de días sean coherentes.
3. **Detalles Técnicos:** Si encuentras comandos o nombres de servidores (ej: srvv_KOHA), asegúrate de que tengan el formato correcto (código o negrita según corresponda).
4. **Conclusión Semanal:** Redacta una síntesis estratégica basada en los registros diarios. Agrupa por: Gestión Operativa, Infraestructura e Integridad de Datos.
5. **Resumen por Recurso:** Consolida las tareas repetitivas en una sola línea por recurso para la tabla final.

---
# 📊 Bitácora SERVIDORES
**Responsable:** Lic. Ricardo MONLA  
**Área:** Departamento Servidores y Sistemas de Altas Prestaciones  
**Oficina:** Dirección de Tecnologías de la Información y la Comunicación (DTIC)  
**Institución:** Universidad Tecnológica Nacional – Facultad Regional La Rioja  

---

## ⏱️ Cronología de Actividades

EOF

# 3. Bucle para generar los días intermedios (Estructura automática)
# Se asume que los días son del mes actual.
for (( i=$DAY_START; i<=$DAY_END; i++ ))
do
    # Formatear día con cero a la izquierda si es necesario (opcional, aquí simple)
    CURRENT_DAY=$(printf "%02d" $i)
    
    cat >> "$FILE_NAME" <<EOF
### 📅 ${CURRENT_DAY}/${MONTH}/${YEAR_FULL}
| Hora        | Recurso         | Detalle |
|-------------|-----------------|---------|
| 08:00_08:00 | **dtic_RECURSO** | Detalle de la tarea... |

EOF
done

# 4. Cierre del archivo con las secciones finales
cat >> "$FILE_NAME" <<EOF

---

## ✅ Conclusión de la Semana
*(Espacio para que la IA genere la síntesis o para apuntes rápidos que la IA deberá procesar)*
* Hito 1: ...
* Hito 2: ...

---

## 📊 Resumen por Recurso - 📅 ${RANGO_FECHAS}

| Recurso | Avance principal |
| --- | --- |
| **dtic_EJEMPLO** | Resumen de la actividad... |

---

## 📌 Pendientes o Próximos pasos
* Verificar...
* Monitorear...
* Documentar...

---

✍️ *Última edición: $(date +"%d/%m/%Y %H:%M")*
EOF

# 5. Permisos y confirmación
chmod +x "$FILE_NAME" 2>/dev/null # Opcional, solo si necesitas ejecutar algo con el md
echo "✅ Bitácora creada exitosamente: $FILE_NAME"
echo "   Puedes abrirla con: nano $FILE_NAME"