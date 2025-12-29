import React from 'react';
import { 
  RefreshCw,
  Database,
  Activity,
  AlertTriangle
} from 'lucide-react';

// --- Helper Functions ---
export const getFormattedDate = (date = new Date()) => {
  return date.toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit', year: 'numeric' });
};

export const getFormattedTime = () => {
  const now = new Date();
  const hours = now.getHours().toString().padStart(2, '0');
  const minutes = now.getMinutes().toString().padStart(2, '0');
  return `${hours}:${minutes}`;
};

export const normalizeInputTime = (timeStr: string): string => {
  if (!timeStr) return '';
  // Extract first occurrence of H:MM or HH:MM
  const match = timeStr.match(/(\d{1,2}):(\d{1,2})/);
  if (match) {
    // Return standard HH:mm format (24h)
    return `${match[1].padStart(2, '0')}:${match[2].padStart(2, '0')}`;
  }
  return '';
};

export const normalizeMarkdown = (content: string): string => {
  // 0. Normalize line endings to standard \n (Fixes Windows/Linux mix)
  let normalized = content.replace(/\r\n/g, '\n').replace(/\r/g, '\n');

  // 1. Ensure standard separators exists before headers if they are missing
  const headersKeywords = ['Cronología', 'Conclusión', 'Resumen', 'Pendientes', 'Pie'];
  
  // 2. Standardize Headers (Fix typos, missing emojis, missing spaces, leading spaces)
  // Fix Cronología
  normalized = normalized.replace(
      /^[\t ]*(#+)\s*.*Cronolog.*Actividades.*/gim, 
      '## ⏱️ Cronología de Actividades'
  );
  // Fallback for simple "Cronología"
  normalized = normalized.replace(
      /^[\t ]*(#+)\s*Cronolog.*$/gim, 
      '## ⏱️ Cronología de Actividades'
  );

  // Fix Conclusión
  normalized = normalized.replace(
      /^[\t ]*(#+)\s*.*Conclusi.*Semana.*/gim, 
      '## ✅ Conclusión de la Semana'
  );
   // Fallback simple
   normalized = normalized.replace(
      /^[\t ]*(#+)\s*Conclusi.*$/gim, 
      '## ✅ Conclusión de la Semana'
  );

  // Fix Resumen
  normalized = normalized.replace(
      /^[\t ]*(#+)\s*.*Resumen.*Recurso.*/gim, 
      '## 📊 Resumen por Recurso'
  );
  
  // Fix Pendientes
  normalized = normalized.replace(
      /^[\t ]*(#+)\s*.*Pendientes.*$/gim, 
      '## 📌 Pendientes o Próximos pasos'
  );

  // Fix Pie
  normalized = normalized.replace(
      /^[\t ]*(#+)\s*Pie.*$/gim, 
      '## ✍️ Pie'
  );

  // 3. Ensure Separators (---) exist before the canonical headers
  const canonicalHeaders = [
      '## ⏱️ Cronología de Actividades',
      '## ✅ Conclusión de la Semana',
      '## 📊 Resumen por Recurso',
      '## 📌 Pendientes o Próximos pasos',
      '## ✍️ Pie'
  ];

  canonicalHeaders.forEach(header => {
      // Escape special regex chars in header
      const safeHeader = header.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      
      if (normalized.includes(header)) {
          // Check if there is already a separator nearby
          // The regex looks for: (Newline OR Newline+Separator) + Whitespace + Header
          const regex = new RegExp(`(\\n---|\\n)\\s*${safeHeader}`, 'g');
          
          // Force a clean separator structure: Double newline, separator, double newline, header
          normalized = normalized.replace(regex, `\n\n---\n\n${header}`);
      }
  });

  // 4. Clean up multiple separators/newlines caused by the step above
  // Replace multiple blank lines with separators into a single separator block
  normalized = normalized.replace(/\n\s*---\s*\n(\s*---\s*\n)+/g, '\n\n---\n\n');
  // Ensure we don't have too many empty lines
  normalized = normalized.replace(/\n{3,}/g, '\n\n');

  return normalized;
};

// --- Constants & Data ---
export const INITIAL_HEADER = `# 📊 Bitácora SERVIDORES
**Responsable:** Lic. Ricardo MONLA  
**Área:** Departamento Servidores y Sistemas de Altas Prestaciones  
**Oficina:** Dirección de Tecnologías de la Información y la Comunicación (DTIC)  
**Institución:** Universidad Tecnológica Nacional – Facultad Regional La Rioja  

---

## ⏱️ Cronología de Actividades
| Hora | Recurso | Detalle |
|---|---|---|

---

## ✅ Conclusión de la Semana
*Sin novedades relevantes.*

---

## 📊 Resumen por Recurso
* **dtic_DIGI:** ...
* **dtic_BKPs:** ...

---

## 📌 Pendientes o Próximos pasos
1. ...

---

## ✍️ Pie
*Última edición: ${getFormattedDate()}*`;

export const RESOURCES = {
  'DTIC (Gestión/General)': [
    'dtic_DIGI', 
    'dtic_TESTServicios', 
    'dtic_BITACORAs', 
    'dtic_UPDATEs', 
    'dtic_BKPs',
    'dtic_MANTENIMIENTOs',
    'dtic_RECURSO'
  ],
  'Servidores Virtuales (SRVV)': [
    'srvv-SITIO', 
    'srvv-SITIO0', 
    'srvv-SITIO2', 
    'srvv-DTIC', 
    'srvv-DOCs', 
    'srvv-DNS', 
    'srvv-KOHA', 
    'srvv-DATA', 
    'srvv-UPTIME', 
    'srvv-FENIX',
    'srvv-SCERO',
    'srvv-MAURIK'
  ],
  'PC Virtuales (PCV)': [
    'pcv-DASU2', 
    'pcv-DASU3', 
    'pcv-SERVIIO'
  ],
  'Servidores Físicos/Otros': [
    'srvv-PMOX1',
    'srvv-PMOX2',
    'srvv-PMOX3',
    'srv-NS8'
  ]
};

// --- Quick Templates Definition ---
export const QUICK_TEMPLATES = [
  {
    id: 'srv_backup',
    label: 'Backup de Servidor',
    icon: <RefreshCw size={14} className="text-blue-600" />,
    resource: 'dtic_BKPs',
    detail: 'Se realiza backup de los siguinetes recursos:',
    subTasks: []
  },  
  {
    id: 'os_update',
    label: 'Update S.O.',
    icon: <RefreshCw size={14} className="text-blue-600" />,
    resource: 'dtic_UPDATEs',
    detail: 'Actualización de paquetes y seguridad del Sistema Operativo en los siguientes recursos:',
    subTasks: []
  },
  {
    id: 'backup_check',
    label: 'Check Backups',
    icon: <Database size={14} className="text-green-600" />,
    resource: 'dtic_BKPs',
    detail: 'Verificación y ejecución de copias de seguridad.',
    subTasks: ['Validación de integridad', 'Sincronización Cloud']
  },
  {
    id: 'service_restart',
    label: 'Reinicio Srv',
    icon: <Activity size={14} className="text-orange-600" />,
    resource: '', // Forces user to pick specific server
    detail: 'Reinicio programado de servicios/servidor para aplicar cambios.',
    subTasks: ['Detención de servicios', 'Reinicio de instancia', 'Validación de logs']
  },
  {
    id: 'incident',
    label: 'Incidente',
    icon: <AlertTriangle size={14} className="text-red-600" />,
    resource: '',
    detail: '⚠️ DETECCIÓN DE INCIDENTE:',
    subTasks: []
  }
];