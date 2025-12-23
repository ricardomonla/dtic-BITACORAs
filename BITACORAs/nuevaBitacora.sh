#!/bin/bash
# ============================================================
#  nuevaBitacora.sh - Generador Automático de Bitácora Semanal
#  Autor: Lic. Ricardo MONLA (DTIC)
#  ------------------------------------------------------------
#  Funcionalidad:
#  1. Detecta automáticamente la semana actual (Lunes a Domingo).
#  2. Genera tablas vacías para cada día.
#  3. Incluye instrucciones (Prompt) para la IA al inicio.
# ============================================================

# --- 1. CÁLCULO DE FECHAS (Semana Lunes-Domingo) ---

# Día actual de la semana (1=Lunes ... 7=Domingo)
DOW=$(date +%u)

# Calcular offset para volver al Lunes
DIAS_ATRAS=$((DOW - 1))

# Fecha de Inicio (Lunes de esta semana)
FECHA_INICIO_FULL=$(date -d "-$DIAS_ATRAS days" +%Y-%m-%d)

# Fecha de Fin (Domingo de esta semana - sumamos 6 días al lunes)
FECHA_FIN_FULL=$(date -d "$FECHA_INICIO_FULL + 6 days" +%Y-%m-%d)

# Variables para nombres y títulos
YY=$(date -d "$FECHA_INICIO_FULL" +%y)
MM=$(date -d "$FECHA_INICIO_FULL" +%m)
DD_INICIO=$(date -d "$FECHA_INICIO_FULL" +%d)
DD_FIN=$(date -d "$FECHA_FIN_FULL" +%d)

# Nombre del archivo: Bitacora_AAMM_DDalDD.md
FILE_NAME="Bitacora_${YY}${MM}_${DD_INICIO}al${DD_FIN}.md"

# Rango legible para el texto (ej: 16/12/2025 al 22/12/2025)
RANGO_TITULO="$(date -d "$FECHA_INICIO_FULL" +%d/%m/%Y) al $(date -d "$FECHA_FIN_FULL" +%d/%m/%Y)"

echo "📘 Semana detectada: $RANGO_TITULO"
echo "📝 Creando archivo: $FILE_NAME ..."

# --- 2. GENERACIÓN DEL CONTENIDO ---

cat > "$FILE_NAME" <<EOF
**Corrige, completa y formatea la bitácora de la semana del ${RANGO_TITULO}** siguiendo el formato institucional DTIC.

**Instrucciones para la IA:**
1. **Revisión:** Corrige ortografía, gramática y coherencia cronológica. Mantén un tono técnico-administrativo.
2. **Formato:** Respeta estrictamente la estructura Markdown, los emojis y las tablas.
3. **Síntesis:** Redacta la sección "Conclusión de la Semana" agrupando los avances en ejes (ej: Gestión, Infraestructura, Backups).
4. **Resumen:** Completa la tabla "Resumen por Recurso" unificando las tareas repetitivas de la semana.
5. **Pendientes:** Extrae acciones futuras o tareas inconclusas para la lista final.

---

# 📊 Bitácora SERVIDORES
**Responsable:** Lic. Ricardo MONLA  
**Área:** Departamento Servidores y Sistemas de Altas Prestaciones  
**Oficina:** Dirección de Tecnologías de la Información y la Comunicación (DTIC)  
**Institución:** Universidad Tecnológica Nacional – Facultad Regional La Rioja  

---

## ⏱️ Cronología de Actividades

EOF

# --- 3. BUCLE DE DÍAS (Lunes a Domingo) ---
# Iteramos 7 días (0 a 6) a partir de la FECHA_INICIO_FULL
for i in {0..6}
do
    FECHA_DIA=$(date -d "$FECHA_INICIO_FULL + $i days" +%d/%m/%Y)
    
    cat >> "$FILE_NAME" <<EOF
### 📅 ${FECHA_DIA}
| Hora        | Recurso         | Detalle |
|-------------|-----------------|---------|
| 16:00_21:00 | **dtic_RECURSO** | ... |

EOF
done

# --- 4. SECCIONES FINALES ---

cat >> "$FILE_NAME" <<EOF
---

## ✅ Conclusión de la Semana
*(Espacio para notas rápidas que la IA deberá procesar y redactar)*
* Hito principal: ...
* Problema resuelto: ...

---

## 📊 Resumen por Recurso - 📅 ${RANGO_TITULO}

| Recurso | Avance principal |
| --- | --- |
| **dtic_DIGI** | ... |
| **dtic_BKPs** | ... |
| **dtic_UPDATEs** | ... |

---

## 📌 Pendientes o Próximos pasos
* [ ] ...
* [ ] ...

---

✍️ *Última edición: $(date +"%d/%m/%Y %H:%M")*
EOF

# --- 5. FIN ---
echo "✅ Bitácora generada exitosamente: $FILE_NAME"