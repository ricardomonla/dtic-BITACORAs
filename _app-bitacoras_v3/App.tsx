import React, { useState, useEffect, useRef } from 'react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import rehypeRaw from 'rehype-raw';
import { 
  Save, 
  Plus, 
  Trash2, 
  Calendar,
  List,
  PlayCircle,
  StopCircle,
  FileJson,
  RefreshCw,
  FileCheck,
  Eye,
  Code,
  ChevronDown,
  ChevronRight,
  Edit2,
  X,
  AlertCircle,
  HelpCircle,
  Download,
  BarChart2,
  PlusCircle,
  Clock
} from 'lucide-react';

import { 
  INITIAL_HEADER, 
  RESOURCES, 
  QUICK_TEMPLATES, 
  getFormattedDate, 
  getFormattedTime,
  normalizeInputTime
} from './constants';

// --- Default Content for Missing Sections ---
const MISSING_SECTIONS_CONFIG = {
    'cronologia': {
        title: '⏱️ Cronología de Actividades',
        content: `| Hora | Recurso | Detalle |\n|---|---|---|`,
        position: 'start' // After metadata
    },
    'conclusion': {
        title: '✅ Conclusión de la Semana',
        content: `*Sin novedades relevantes.*`,
        position: 'middle'
    },
    'resumen': {
        title: '📊 Resumen por Recurso',
        content: `* **dtic_DIGI:** ...\n* **dtic_BKPs:** ...`,
        position: 'middle'
    },
    'pendientes': {
        title: '📌 Pendientes o Próximos pasos',
        content: `1. ...`,
        position: 'middle'
    },
    'pie': {
        title: '✍️ Pie',
        content: `*Última edición: ${getFormattedDate()}*`,
        position: 'end'
    }
};

const App = () => {
  // --- State ---
  const [markdownContent, setMarkdownContent] = useState<string>(INITIAL_HEADER);
  const [isLoaded, setIsLoaded] = useState(false);
  
  // View State
  const [viewMode, setViewMode] = useState<'rich' | 'raw'>('rich');
  
  // Collapsed Sections State (id -> boolean)
  const [expandedSections, setExpandedSections] = useState<Record<string, boolean>>({});

  // --- Modes of Operation (Sidebar) ---
  const [editingLineIndex, setEditingLineIndex] = useState<number | null>(null);
  const [editingContext, setEditingContext] = useState<'chronology' | 'summary'>('chronology');
  
  const [editingSectionTitle, setEditingSectionTitle] = useState<string | null>(null);
  const [sectionContentBuffer, setSectionContentBuffer] = useState<string>('');

  // Form State (for Entries)
  const [selectedDate, setSelectedDate] = useState<string>(new Date().toISOString().split('T')[0]);
  const [startTime, setStartTime] = useState<string>('');
  const [endTime, setEndTime] = useState<string>('');
  const [selectedResource, setSelectedResource] = useState<string>('');
  const [mainDetail, setMainDetail] = useState<string>('');
  
  // SubTasks State
  const [subTasks, setSubTasks] = useState<string[]>([]);
  const [currentSubTask, setCurrentSubTask] = useState<string>('');
  const [subTaskTime, setSubTaskTime] = useState<string>('');
  const [editingSubTaskIndex, setEditingSubTaskIndex] = useState<number | null>(null);

  const textAreaRef = useRef<HTMLTextAreaElement>(null);
  const previewRef = useRef<HTMLDivElement>(null);

  // --- Effects ---
  
  // 1. Load data from LocalStorage on mount
  useEffect(() => {
    const savedContent = localStorage.getItem('dtic_bitacora_content');
    const savedDate = localStorage.getItem('dtic_bitacora_date');
    
    if (savedContent) {
      setMarkdownContent(savedContent);
    }
    if (savedDate) {
      setSelectedDate(savedDate);
    }
    setIsLoaded(true);
    setStartTime(getFormattedTime());
  }, []);

  // 2. Auto-save to LocalStorage
  useEffect(() => {
    if (isLoaded) {
      localStorage.setItem('dtic_bitacora_content', markdownContent);
      localStorage.setItem('dtic_bitacora_date', selectedDate);
    }
  }, [markdownContent, selectedDate, isLoaded]);

  // 3. Auto-scroll logic (for raw view)
  useEffect(() => {
    if (viewMode === 'raw' && textAreaRef.current) {
        const { scrollTop, scrollHeight, clientHeight } = textAreaRef.current;
        if (scrollHeight - scrollTop - clientHeight < 150) {
            textAreaRef.current.scrollTop = scrollHeight;
        }
    } 
  }, [markdownContent, viewMode]);

  // --- Handlers ---

  const handleManualCodeChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
      // Normalize line endings immediately to prevent parsing issues down the line
      const val = e.target.value.replace(/\r\n/g, '\n').replace(/\r/g, '\n');
      setMarkdownContent(val);
  };

  // --- SECTION MANAGEMENT HANDLERS ---
  
  const handleAddMissingSection = (key: keyof typeof MISSING_SECTIONS_CONFIG) => {
      const config = MISSING_SECTIONS_CONFIG[key];
      if (!config) return;

      setMarkdownContent(prev => {
          const lines = prev.split('\n');
          const newSectionBlock = `\n\n## ${config.title}\n${config.content}\n\n---`;
          
          if (config.position === 'end') {
              // Append to end
              return prev.trim() + newSectionBlock;
          } 
          
          if (config.position === 'start') {
              // Find end of metadata (first section without ## or before first ##)
              let insertIndex = lines.length;
              for(let i=0; i<lines.length; i++) {
                  if (lines[i].trim().startsWith('## ')) {
                      insertIndex = i;
                      break;
                  }
              }
              // If we found a section, verify if there is a separator before it
              if (insertIndex > 0 && lines[insertIndex-1].trim() === '---') {
                  insertIndex--; // Insert before the separator
              }
              
              const before = lines.slice(0, insertIndex).join('\n');
              const after = lines.slice(insertIndex).join('\n');
              return `${before}\n\n---\n\n## ${config.title}\n${config.content}${after}`;
          }

          if (config.position === 'middle') {
              // Try to insert before 'Pie' or at the end if Pie doesn't exist
              let pieIndex = -1;
               for(let i=0; i<lines.length; i++) {
                  if (lines[i].trim().includes('Pie') && lines[i].trim().startsWith('##')) {
                      pieIndex = i;
                      break;
                  }
              }

              if (pieIndex !== -1) {
                  // Insert before Pie
                  // Backtrack to separator
                   if (pieIndex > 0 && lines[pieIndex-1].trim() === '---') {
                      pieIndex--; 
                  }
                  const before = lines.slice(0, pieIndex).join('\n');
                  const after = lines.slice(pieIndex).join('\n');
                  return `${before}${newSectionBlock}${after}`;
              } else {
                  return prev.trim() + newSectionBlock;
              }
          }

          return prev;
      });
  };

  // --- SECTION EDITING HANDLERS ---

  const handleEditSectionStart = (title: string, currentContentLines: string[]) => {
      const cleanContent = currentContentLines.join('\n').trim();
      setEditingSectionTitle(title);
      setSectionContentBuffer(cleanContent);
      setEditingLineIndex(null);
      
      const simpleId = `section-${title.replace(/\s+/g, '-').toLowerCase()}`;
      setExpandedSections(prev => ({...prev, [simpleId]: true}));
  };

  const handleSaveSection = () => {
      if (!editingSectionTitle) return;

      setMarkdownContent(prevContent => {
          const lines = prevContent.split('\n');
          
          let startIndex = -1;
          let endIndex = lines.length;

          // Special handling for Metadata (Top of file)
          if (editingSectionTitle === "Cabecera / Metadatos") {
             startIndex = 0;
             for(let i = 0; i < lines.length; i++) {
                 if (lines[i].trim().startsWith('## ')) {
                     endIndex = i;
                     break;
                 }
             }
             
             // If we found the bounds
             const after = lines.slice(endIndex);
             return [
                 sectionContentBuffer.trim(),
                 '',
                 ...after
             ].join('\n');

          } else {
              // Standard Sections logic
              const titleHeader = `## ${editingSectionTitle}`;
              startIndex = lines.findIndex(l => l.trim().includes(titleHeader.trim())); 
              
              if (startIndex === -1) return prevContent;

              for(let i = startIndex + 1; i < lines.length; i++) {
                  if (lines[i].trim().startsWith('## ')) {
                      endIndex = i;
                      break;
                  }
              }

              const before = lines.slice(0, startIndex + 1);
              const after = lines.slice(endIndex);
              
              return [
                  ...before,
                  sectionContentBuffer.trim(),
                  '',
                  ...after
              ].join('\n');
          }
      });

      setEditingSectionTitle(null);
      setSectionContentBuffer('');
  };

  const handleCancelSectionEdit = () => {
      setEditingSectionTitle(null);
      setSectionContentBuffer('');
  };

  // --- ENTRY EDITING HANDLERS ---

  const handleApplyTemplate = (template: typeof QUICK_TEMPLATES[0]) => {
    if (template.resource) setSelectedResource(template.resource);
    setMainDetail(template.detail);
    setSubTasks(template.subTasks || []);
    setStartTime(getFormattedTime());
    setEndTime('');
    setEditingLineIndex(null);
    setEditingSectionTitle(null);
    setEditingContext('chronology'); // Templates usually apply to chronology
  };

  // --- SUBTASKS LOGIC ---
  
  const parseSubTaskString = (str: string) => {
    // Regex: Starts with HH:MM (possibly with seconds or other chars), followed by separator
    // Enhanced regex to catch HH:MM:SS or just HH:MM
    const match = str.match(/^(\d{1,2}:\d{2}(?::\d{2})?)\s*[-–]\s*(.*)$/);
    if (match) {
        return { time: normalizeInputTime(match[1]), text: match[2] };
    }
    return { time: '', text: str };
  };

  const handleAddSubTask = () => {
    if (!currentSubTask.trim()) return;
    
    let finalTaskString = currentSubTask.trim();
    if (subTaskTime.trim()) {
        finalTaskString = `${subTaskTime.trim()} - ${finalTaskString}`;
    }

    if (editingSubTaskIndex !== null) {
        // Update existing
        const newSubTasks = [...subTasks];
        newSubTasks[editingSubTaskIndex] = finalTaskString;
        setSubTasks(newSubTasks);
        setEditingSubTaskIndex(null);
    } else {
        // Add new
        setSubTasks([...subTasks, finalTaskString]);
    }
    
    setCurrentSubTask('');
    setSubTaskTime('');
  };

  const handleRemoveSubTask = (index: number) => {
    setSubTasks(subTasks.filter((_, i) => i !== index));
    if (editingSubTaskIndex === index) {
        setEditingSubTaskIndex(null);
        setCurrentSubTask('');
        setSubTaskTime('');
    }
  };

  const handleStartEditSubTask = (index: number) => {
    const taskStr = subTasks[index];
    const { time, text } = parseSubTaskString(taskStr);
    setSubTaskTime(time);
    setCurrentSubTask(text);
    setEditingSubTaskIndex(index);
  };

  const handleCancelSubTaskEdit = () => {
      setEditingSubTaskIndex(null);
      setCurrentSubTask('');
      setSubTaskTime('');
  }

  // --- TIME UTILS ---

  const setTimeNow = (type: 'start' | 'end') => {
    const time = getFormattedTime();
    if (type === 'start') setStartTime(time);
    else setEndTime(time);
  };
  
  const setSubTaskTimeNow = () => {
      setSubTaskTime(getFormattedTime());
  }

  const toggleSection = (id: string) => {
    setExpandedSections(prev => ({
        ...prev,
        [id]: !prev[id]
    }));
  };

  const constructLogEntryRow = () => {
      let detailContent = mainDetail;
      if (subTasks.length > 0) {
        const listItems = subTasks.map(task => `<li>${task}</li>`).join('');
        detailContent += ` <ul>${listItems}</ul>`;
      }

      if (editingContext === 'summary') {
          // 2 Columns: Recurso | Detalle
          return `| **${selectedResource}** | ${detailContent} |`;
      } else {
          // 3 Columns: Hora | Recurso | Detalle
          const finalEndTime = endTime || startTime; 
          const timeRange = `${startTime}_${finalEndTime}`;
          return `| ${timeRange} | **${selectedResource}** | ${detailContent} |`;
      }
  }

  const insertLogEntry = () => {
    if (!selectedResource) return;
    // For chronology, we need startTime. For summary, we don't.
    if (editingContext === 'chronology' && !startTime) return;

    const newRow = constructLogEntryRow();

    if (editingLineIndex !== null) {
        // UPDATE EXISTING ENTRY
        setMarkdownContent(prevContent => {
            const lines = prevContent.split('\n');
            if (editingLineIndex >= 0 && editingLineIndex < lines.length) {
                lines[editingLineIndex] = newRow;
                return lines.join('\n');
            }
            return prevContent;
        });
        setEditingLineIndex(null); 
    } else {
        // CREATE NEW ENTRY (Defaulting to Chronology logic mostly)
        if (editingContext === 'summary') {
             alert("La creación de nuevas entradas está optimizada para la Cronología. Para agregar al Resumen, edita la sección manualmente o duplica una fila existente.");
             return;
        }

        const displayDate = getFormattedDate(new Date(selectedDate));
        const dateHeader = `### 📅 ${displayDate}`;
        
        setMarkdownContent(prevContent => {
          const lines = prevContent.split('\n');
          
          const cronoStartIndex = lines.findIndex(l => {
              const t = l.trim();
              return t.startsWith('##') && t.toLowerCase().includes('cronolog');
          });
          
          if (cronoStartIndex === -1) {
              return prevContent + `\n\n## ⏱️ Cronología de Actividades\n\n${dateHeader}\n| Hora | Recurso | Detalle |\n|---|---|---|\n${newRow}\n`;
          }

          let cronoEndIndex = lines.length;
          for(let i = cronoStartIndex + 1; i < lines.length; i++) {
              if (lines[i].trim().startsWith('## ')) {
                  cronoEndIndex = i;
                  break;
              }
          }
          
          let insertIndex = -1;
          let foundDate = false;

          for (let i = cronoStartIndex; i < cronoEndIndex; i++) {
              if (lines[i].trim() === dateHeader) {
                  foundDate = true;
                  let j = i + 1;
                  while(j < cronoEndIndex) {
                      const line = lines[j].trim();
                      if (line.startsWith('### ') || line.startsWith('## ') || line === '---') {
                          break;
                      }
                      j++;
                  }
                  insertIndex = j;
                  break;
              }
          }

          const newLines = [...lines];

          if (foundDate && insertIndex !== -1) {
              newLines.splice(insertIndex, 0, newRow);
          } else {
              let targetIndex = cronoEndIndex;
              if (targetIndex > 0 && lines[targetIndex - 1].trim() === '---') {
                  targetIndex--;
              }
              
              const tableHeader = `| Hora | Recurso | Detalle |\n|---|---|---|`;
              const block = `\n${dateHeader}\n${tableHeader}\n${newRow}\n`;
              newLines.splice(targetIndex, 0, block);
          }

          return newLines.join('\n');
        });

        const cronoIdKey = Object.keys(expandedSections).find(k => k.includes('cronolog')) || 'section-cronología-de-actividades';
        setExpandedSections(prev => ({...prev, [cronoIdKey]: true}));
        
        setStartTime(endTime || startTime); 
        setEndTime('');
    }

    setMainDetail('');
    setSubTasks([]);
    setSubTaskTime('');
    setEditingContext('chronology'); // Reset to default
  };

  const handleCancelEdit = () => {
      setEditingLineIndex(null);
      setMainDetail('');
      setSubTasks([]);
      setSubTaskTime('');
      setStartTime(getFormattedTime());
      setEndTime('');
      setEditingContext('chronology');
  };

  const handleEditRowClick = (e: React.MouseEvent, lineIndex: number, rowText: string, type: 'chronology' | 'summary') => {
      // Prevent the click from bubbling up to the section click handler
      e.stopPropagation();
      
      setEditingSectionTitle(null);
      setEditingContext(type);

      try {
          const cleanRow = rowText.replace(/^\|/, '').replace(/\|$/, '');
          const cols = cleanRow.split('|').map(c => c.trim());

          // CHRONOLOGY: 3 Columns (Time | Resource | Detail)
          if (type === 'chronology' && cols.length >= 3) {
              const times = cols[0].split('_');
              setStartTime(normalizeInputTime(times[0] || ''));
              setEndTime(normalizeInputTime(times[1] || ''));

              const res = cols[1].replace(/\*\*/g, '').trim();
              setSelectedResource(res);

              let detailRaw = cols[2];
              const ulMatch = detailRaw.match(/<ul>(.*?)<\/ul>/);
              let extractedSubtasks: string[] = [];
              let extractedDetail = detailRaw;

              if (ulMatch) {
                   const listContent = ulMatch[1];
                   extractedDetail = detailRaw.replace(ulMatch[0], '').trim();
                   const liRegex = /<li>(.*?)<\/li>/g;
                   const matches = [...listContent.matchAll(liRegex)];
                   extractedSubtasks = matches.map(m => m[1]);
              }

              setMainDetail(extractedDetail);
              setSubTasks(extractedSubtasks);
              setEditingLineIndex(lineIndex);
          }
          // SUMMARY: 2 Columns (Resource | Detail)
          else if (type === 'summary' && cols.length >= 2) {
              setStartTime('');
              setEndTime('');

              // Col 0 is Resource
              const res = cols[0].replace(/\*\*/g, '').trim();
              setSelectedResource(res);

              // Col 1 is Detail
              let detailRaw = cols[1];
              const ulMatch = detailRaw.match(/<ul>(.*?)<\/ul>/);
              let extractedSubtasks: string[] = [];
              let extractedDetail = detailRaw;

              if (ulMatch) {
                   const listContent = ulMatch[1];
                   extractedDetail = detailRaw.replace(ulMatch[0], '').trim();
                   const liRegex = /<li>(.*?)<\/li>/g;
                   const matches = [...listContent.matchAll(liRegex)];
                   extractedSubtasks = matches.map(m => m[1]);
              }

              setMainDetail(extractedDetail);
              setSubTasks(extractedSubtasks);
              setEditingLineIndex(lineIndex);
          }
      } catch (e) {
          console.error("Error parsing row", e);
      }
  }

  const handleDownload = () => {
    const element = document.createElement("a");
    const file = new Blob([markdownContent], {type: 'text/markdown'});
    element.href = URL.createObjectURL(file);
    element.download = `bitacora_${selectedDate}.md`;
    document.body.appendChild(element);
    element.click();
  };

  const renderAddSectionButton = (key: keyof typeof MISSING_SECTIONS_CONFIG) => {
      const config = MISSING_SECTIONS_CONFIG[key];
      return (
          <div key={`add-${key}`} className="py-2">
              <button 
                  onClick={() => handleAddMissingSection(key)}
                  className="w-full border-2 border-dashed border-slate-300 rounded-lg p-3 text-slate-400 hover:text-blue-600 hover:border-blue-400 hover:bg-blue-50 transition-all flex items-center justify-center gap-2 group"
              >
                  <PlusCircle size={20} className="group-hover:scale-110 transition-transform" />
                  <span className="font-semibold text-sm">Agregar Sección: {config.title.replace(/^[#\s]*/, '')}</span>
              </button>
          </div>
      );
  }

  // --- Logic for Split Sections View ---
  const renderPreviewSections = () => {
      const sections = [];
      const lines = markdownContent.split('\n');
      
      // Flags to track existing sections
      const presentSections = {
          cronologia: false,
          conclusion: false,
          resumen: false,
          pendientes: false,
          pie: false
      };

      let currentSection = {
          title: "Cabecera / Metadatos",
          id: "section-metadata",
          contentLines: [] as string[],
          type: 'metadata',
          startLineIndex: 0 
      };

      lines.forEach((line, index) => {
          const trimmed = line.trim();
          if (trimmed.startsWith('##') && !trimmed.startsWith('###')) {
              sections.push(currentSection);
              
              const rawTitle = trimmed.replace(/^##\s*/, '').trim();
              const simpleId = `section-${rawTitle.replace(/[^\w\s-]/g, '').replace(/\s+/g, '-').toLowerCase()}`;
              
              let type = 'custom';
              const lowerTitle = rawTitle.toLowerCase();
              if (lowerTitle.includes('cronolog')) { type = 'standard'; presentSections.cronologia = true; }
              if (lowerTitle.includes('resumen')) { type = 'standard'; presentSections.resumen = true; }
              if (lowerTitle.includes('conclusi')) { type = 'standard'; presentSections.conclusion = true; }
              if (lowerTitle.includes('pendiente')) { type = 'standard'; presentSections.pendientes = true; }
              if (lowerTitle.includes('pie')) { type = 'footer'; presentSections.pie = true; }

              currentSection = {
                  title: rawTitle,
                  id: simpleId,
                  contentLines: [],
                  type: type,
                  startLineIndex: index + 1
              };
          } else {
              currentSection.contentLines.push(line);
          }
      });
      sections.push(currentSection);

      // --- Rendering Logic with Injection of Missing Sections ---
      
      const elementsToRender: React.ReactNode[] = [];

      // 1. Always Render Metadata (first section in parsed array)
      const metadataSection = sections[0];
      elementsToRender.push(renderSectionCard(metadataSection, 0));

      // 2. Check Cronologia
      if (!presentSections.cronologia) {
          elementsToRender.push(renderAddSectionButton('cronologia'));
      }

      // 3. Render all other existing sections (except Pie, which we force to end)
      const standardSections = sections.slice(1);
      const pieSection = standardSections.find(s => s.type === 'footer' || s.title.toLowerCase().includes('pie'));
      
      standardSections.forEach((section, idx) => {
          if (section !== pieSection) {
              elementsToRender.push(renderSectionCard(section, idx + 1));
          }
      });

      // 4. Check Middle Missing Sections
      if (!presentSections.conclusion) elementsToRender.push(renderAddSectionButton('conclusion'));
      if (!presentSections.resumen) elementsToRender.push(renderAddSectionButton('resumen'));
      if (!presentSections.pendientes) elementsToRender.push(renderAddSectionButton('pendientes'));

      // 5. Render Pie or Add Button
      if (pieSection) {
          // If we found a pie section, render it last
          elementsToRender.push(renderSectionCard(pieSection, sections.length + 1));
      } else {
          elementsToRender.push(renderAddSectionButton('pie'));
      }

      return (
        <div ref={previewRef} className="flex-1 overflow-y-auto custom-scrollbar bg-slate-100 p-4 space-y-3 relative">
            {elementsToRender}
        </div>
      );
  };

  // Helper to render a single section card
  const renderSectionCard = (section: any, idx: number) => {
        if (section.type === 'metadata' && section.contentLines.join('').trim() === '') {
            return null;
        }

        const isExpanded = expandedSections[section.id] || false;
        const body = section.contentLines.join('\n');
        const isEmpty = body.trim().length === 0;
        
        const isCronologia = section.title.toLowerCase().includes('cronolog');
        const isResumen = section.title.toLowerCase().includes('resumen');
        
        const isTextSection = !isCronologia && !isResumen;

        let borderColor = 'border-slate-200';
        let icon = <List size={18} className="text-slate-400"/>;
        
        if (section.type === 'custom') {
            borderColor = 'border-orange-200';
            icon = <HelpCircle size={18} className="text-orange-400"/>;
        } else if (isCronologia) {
            icon = <Calendar size={18} className="text-blue-500"/>;
        } else if (isResumen) {
            icon = <BarChart2 size={18} className="text-purple-500"/>;
        }

        return (
            <div key={section.id + idx} className={`bg-white rounded-lg border shadow-sm overflow-hidden transition-all duration-300 ${borderColor}`}>
                {/* Section Header */}
                <div 
                    onClick={() => toggleSection(section.id)}
                    className={`w-full flex items-center justify-between p-4 cursor-pointer transition-colors ${isExpanded ? 'bg-white' : 'bg-slate-50 hover:bg-white'}`}
                >
                        <div className="flex-1 flex items-center gap-3">
                        {isExpanded ? <ChevronDown size={18} className="text-blue-500"/> : <ChevronRight size={18} className="text-slate-400"/>}
                        <div className="flex items-center gap-2">
                            {icon}
                            <h3 className={`font-bold text-sm ${isExpanded ? 'text-slate-800' : 'text-slate-600'}`}>
                                {section.title}
                            </h3>
                            {section.type === 'custom' && (
                                <span className="text-[10px] bg-orange-100 text-orange-700 px-2 py-0.5 rounded-full uppercase font-bold tracking-wider">
                                    Personalizado
                                </span>
                            )}
                        </div>
                    </div>

                    <div className="flex items-center gap-2">
                        <span className="text-xs text-slate-400 font-mono mr-2">
                            {isEmpty ? 'Vacío' : `${section.contentLines.length} líneas`}
                        </span>
                    </div>
                </div>

                {/* Section Body */}
                {isExpanded && (
                    <div 
                        className={`border-t border-slate-100 p-6 animate-in slide-in-from-top-2 duration-200 
                            ${isTextSection ? 'cursor-pointer hover:bg-slate-50 transition-colors' : ''}
                        `}
                        onClick={() => {
                            if(isTextSection) {
                                handleEditSectionStart(section.title, section.contentLines);
                            }
                        }}
                        title={isTextSection ? "Haz clic para editar esta sección" : ""}
                    >
                        <div className="markdown-preview text-sm">
                            <ReactMarkdown 
                                remarkPlugins={[remarkGfm]}
                                rehypePlugins={[rehypeRaw]}
                                components={{
                                    table: ({children, ...props}) => (
                                        <table className="w-full border-collapse border border-slate-200 mb-4 table-auto text-xs" {...props}>{children}</table>
                                    ),
                                    th: ({children, ...props}) => (
                                        <th className="border border-slate-200 p-2 bg-slate-50 font-bold text-slate-700 text-left" {...props}>{children}</th>
                                    ),
                                    td: ({children, ...props}) => (
                                        <td className="border border-slate-200 p-2 align-top text-slate-600" {...props}>{children}</td>
                                    ),
                                    tr: ({node, children, ...props}) => {
                                        const relativeLine = node?.position?.start?.line;
                                        const globalLineIndex = (relativeLine && section.startLineIndex !== undefined) 
                                            ? section.startLineIndex + relativeLine - 1 
                                            : null;

                                        const rawLine = globalLineIndex !== null ? markdownContent.split('\n')[globalLineIndex] : "";
                                        const isHeader = node?.children?.some((child: any) => child.tagName === 'th');

                                        if (isHeader || !rawLine || !rawLine.includes('|')) {
                                            return <tr className="hover:bg-slate-50" {...props}>{children}</tr>
                                        }
                                        
                                        if (isCronologia) {
                                            const isEditing = editingLineIndex === globalLineIndex;
                                            return (
                                                <tr 
                                                    {...props} 
                                                    onClick={(e) => handleEditRowClick(e, globalLineIndex!, rawLine, 'chronology')}
                                                    title="Editar entrada de cronología"
                                                    className={`cursor-pointer transition-colors ${isEditing ? '!bg-amber-50 !border-l-4 !border-l-amber-500' : 'hover:bg-blue-50'}`}
                                                >
                                                    {children}
                                                </tr>
                                            )
                                        } else if (isResumen) {
                                            const isEditing = editingLineIndex === globalLineIndex;
                                            return (
                                                <tr 
                                                    {...props} 
                                                    onClick={(e) => handleEditRowClick(e, globalLineIndex!, rawLine, 'summary')}
                                                    title="Editar entrada de resumen"
                                                    className={`cursor-pointer transition-colors ${isEditing ? '!bg-amber-50 !border-l-4 !border-l-amber-500' : 'hover:bg-purple-50'}`}
                                                >
                                                    {children}
                                                </tr>
                                            )
                                        }
                                        
                                        return <tr className="hover:bg-slate-50" {...props}>{children}</tr>
                                    }
                                }}
                            >
                                {body}
                            </ReactMarkdown>
                        </div>
                    </div>
                )}
            </div>
        );
  };

  return (
    <div className="flex flex-col h-screen bg-slate-100 font-sans">
      <header className="bg-slate-900 text-white p-3 flex justify-between items-center shadow-md shrink-0 z-20">
        <div className="flex items-center gap-3">
          <div className="bg-blue-600 p-1.5 rounded">
             <FileJson size={20} className="text-white" />
          </div>
          <div>
             <h1 className="font-bold text-lg leading-tight">dtic-BITACORAs</h1>
             <p className="text-xs text-slate-400">Departamento de Servidores</p>
          </div>
        </div>
        <div className="flex gap-2 items-center">
          <button 
            onClick={handleDownload}
            className="px-4 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded text-xs font-bold flex items-center gap-2 transition-colors shadow-sm"
            title="Descargar archivo .md"
          >
             <Download size={14} /> EXPORTAR
          </button>
        </div>
      </header>

      <main className="flex-1 flex overflow-hidden">
        
        <section className="flex-1 flex flex-col bg-slate-100 border-r border-slate-300 relative shadow-inner">
          <div className="bg-slate-50 px-4 py-2 border-b border-slate-200 flex justify-between items-center shrink-0">
             <div className="flex items-center gap-4">
                 <button 
                    onClick={() => setViewMode('rich')}
                    className={`flex items-center gap-2 text-xs font-bold px-3 py-1.5 rounded transition-all ${viewMode === 'rich' ? 'bg-white text-blue-600 shadow-sm border border-slate-200' : 'text-slate-500 hover:text-slate-700'}`}
                 >
                    <Eye size={14} /> Vista Secciones
                 </button>
                 <button 
                    onClick={() => setViewMode('raw')}
                    className={`flex items-center gap-2 text-xs font-bold px-3 py-1.5 rounded transition-all ${viewMode === 'raw' ? 'bg-white text-blue-600 shadow-sm border border-slate-200' : 'text-slate-500 hover:text-slate-700'}`}
                 >
                    <Code size={14} /> Código Markdown (Pegar aquí)
                 </button>
             </div>
             
             {viewMode === 'raw' && <span className="text-[10px] text-orange-500 font-medium animate-pulse">✏️ Edición Manual Activa</span>}
          </div>
          
          {viewMode === 'raw' ? (
              <textarea
                ref={textAreaRef}
                value={markdownContent}
                onChange={handleManualCodeChange}
                placeholder="Pega tu código Markdown aquí..."
                className="flex-1 p-6 font-mono text-sm resize-none focus:outline-none text-slate-800 leading-relaxed bg-white w-full border-none"
                spellCheck={false}
              />
          ) : (
              renderPreviewSections()
          )}
        </section>

        <section className={`w-[420px] flex flex-col border-l border-slate-200 shadow-2xl z-10 transition-colors ${editingLineIndex !== null || editingSectionTitle ? 'bg-amber-50' : 'bg-slate-50'}`}>
          <div className="flex-1 overflow-y-auto custom-scrollbar">
              {editingSectionTitle ? (
                /* SECTION EDITOR */
                <div className="p-5 space-y-4 h-full flex flex-col">
                    <div className="flex items-center justify-between border-b border-amber-200 pb-3 mb-2">
                        <h3 className="text-sm font-bold text-amber-700 flex items-center gap-2">
                            <Edit2 size={16} /> Editando Sección
                        </h3>
                        <button onClick={handleCancelSectionEdit} className="text-xs text-slate-400 hover:text-slate-600 flex items-center gap-1">
                            <X size={12}/> Cancelar
                        </button>
                    </div>
                    
                    <div className="bg-amber-50 p-2 rounded border border-amber-100 text-xs font-semibold text-amber-800 mb-2">
                        {editingSectionTitle}
                    </div>

                    <div className="flex-1 flex flex-col">
                        <label className="block text-xs font-semibold text-slate-500 mb-2">Contenido (Markdown)</label>
                        <textarea 
                            value={sectionContentBuffer}
                            onChange={(e) => setSectionContentBuffer(e.target.value)}
                            className="flex-1 w-full p-3 border border-slate-300 rounded text-sm bg-white text-slate-700 focus:ring-2 focus:ring-amber-500 focus:outline-none resize-none font-mono"
                            placeholder="Escribe aquí el contenido de la sección..."
                        />
                    </div>

                    <button 
                        onClick={handleSaveSection}
                        className="w-full py-3 bg-amber-600 hover:bg-amber-700 text-white rounded font-medium shadow-sm transition-all flex justify-center items-center gap-2"
                    >
                        <Save size={16} /> Guardar Cambios
                    </button>
                </div>
              ) : (
                /* ENTRY EDITOR */
                <div className="p-5 space-y-6">
                    <div className="bg-white p-4 rounded-lg shadow-sm border border-slate-200">
                        <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3 flex items-center gap-2">
                        <Calendar size={14} /> Fecha de Registro
                        </h3>
                        <input 
                        type="date" 
                        value={selectedDate}
                        onChange={(e) => setSelectedDate(e.target.value)}
                        className="w-full p-2 border border-slate-300 rounded text-sm bg-slate-50 focus:ring-2 focus:ring-blue-500 focus:outline-none font-medium text-slate-700"
                        />
                    </div>

                    <div className={`bg-white p-4 rounded-lg shadow-sm border space-y-4 ${editingLineIndex !== null ? 'border-amber-300 ring-2 ring-amber-100' : 'border-slate-200'}`}>
                        <div className="flex items-center justify-between border-b border-slate-100 pb-2">
                            <h3 className={`text-sm font-bold flex items-center gap-2 ${editingLineIndex !== null ? 'text-amber-700' : 'text-slate-700'}`}>
                                {editingLineIndex !== null ? (
                                    <><Edit2 size={16} /> Editando Entrada</>
                                ) : (
                                    <><Plus size={16} className="text-blue-600" /> Nueva Entrada</>
                                )}
                            </h3>
                            {editingLineIndex !== null && (
                                <button onClick={handleCancelEdit} className="text-xs text-slate-400 hover:text-slate-600 flex items-center gap-1">
                                    <X size={12}/> Cancelar
                                </button>
                            )}
                        </div>
                        
                        {/* Context Badge */}
                        {editingContext === 'summary' && editingLineIndex !== null && (
                            <div className="bg-purple-100 text-purple-800 text-xs px-2 py-1 rounded font-semibold text-center">
                                Tabla: Resumen por Recurso (Sin horarios)
                            </div>
                        )}

                        {editingLineIndex === null && (
                            <div className="grid grid-cols-2 gap-2 mb-2">
                            {QUICK_TEMPLATES.map(tmpl => (
                                <button 
                                    key={tmpl.id}
                                    onClick={() => handleApplyTemplate(tmpl)}
                                    className="flex items-center gap-2 p-2 bg-slate-50 hover:bg-blue-50 border border-slate-200 hover:border-blue-200 rounded transition-colors text-left group"
                                >
                                    <div className="bg-white p-1 rounded shadow-sm border border-slate-100 group-hover:border-blue-100">
                                    {tmpl.icon}
                                    </div>
                                    <span className="text-xs font-medium text-slate-600 group-hover:text-blue-700">{tmpl.label}</span>
                                </button>
                            ))}
                            </div>
                        )}

                        <div>
                            <label className="block text-xs font-semibold text-slate-500 mb-1">Recurso (Resource)</label>
                            <div className="relative">
                                <select 
                                value={selectedResource}
                                onChange={(e) => setSelectedResource(e.target.value)}
                                className="w-full p-2.5 border border-slate-300 rounded text-sm bg-slate-50 focus:ring-2 focus:ring-blue-500 focus:outline-none appearance-none"
                                >
                                <option value="">-- Seleccionar Recurso --</option>
                                {Object.entries(RESOURCES).map(([category, items]) => (
                                    <optgroup key={category} label={category}>
                                    {items.map(item => (
                                        <option key={item} value={item}>{item}</option>
                                    ))}
                                    </optgroup>
                                ))}
                                </select>
                                <div className="absolute right-3 top-3 pointer-events-none text-slate-400">▼</div>
                            </div>
                        </div>

                        {/* Only show time inputs if we are in Chronology mode */}
                        {editingContext === 'chronology' && (
                            <div className="grid grid-cols-2 gap-3">
                                <div>
                                    <label className="block text-xs font-semibold text-slate-500 mb-1">Inicio</label>
                                    <div className="flex">
                                    <input 
                                        type="time" 
                                        value={startTime}
                                        onChange={(e) => setStartTime(e.target.value)}
                                        step="60"
                                        className="w-full p-2 border border-r-0 border-slate-300 rounded-l text-sm bg-slate-50 text-slate-700 focus:outline-none"
                                    />
                                    <button onClick={() => setTimeNow('start')} className="bg-slate-100 border border-slate-300 px-2 rounded-r hover:bg-slate-200" title="Ahora">
                                        <PlayCircle size={14} className="text-green-600"/>
                                    </button>
                                    </div>
                                </div>
                                <div>
                                    <label className="block text-xs font-semibold text-slate-500 mb-1">Fin</label>
                                    <div className="flex">
                                    <input 
                                        type="time" 
                                        value={endTime}
                                        onChange={(e) => setEndTime(e.target.value)}
                                        step="60"
                                        className="w-full p-2 border border-r-0 border-slate-300 rounded-l text-sm bg-slate-50 text-slate-700 focus:outline-none"
                                    />
                                    <button onClick={() => setTimeNow('end')} className="bg-slate-100 border border-slate-300 px-2 rounded-r hover:bg-slate-200" title="Ahora">
                                        <StopCircle size={14} className="text-red-500"/>
                                    </button>
                                    </div>
                                </div>
                            </div>
                        )}

                        <div>
                        <label className="block text-xs font-semibold text-slate-500 mb-1">Detalle Principal</label>
                        <textarea 
                            value={mainDetail}
                            onChange={(e) => setMainDetail(e.target.value)}
                            placeholder="Descripción general de la tarea..."
                            className="w-full p-2 border border-slate-300 rounded text-sm bg-slate-50 text-slate-700 focus:ring-2 focus:ring-blue-500 focus:outline-none min-h-[60px]"
                        />
                        </div>

                        <div className="bg-slate-50 p-3 rounded border border-slate-200">
                        <label className="block text-xs font-semibold text-slate-500 mb-2 flex items-center gap-1">
                            <List size={12} /> Sub-tareas (Se crean como lista)
                        </label>
                        
                        {subTasks.length > 0 && (
                            <ul className="mb-3 space-y-1">
                            {subTasks.map((task, idx) => {
                                const { time, text } = parseSubTaskString(task);
                                const isEditing = editingSubTaskIndex === idx;
                                return (
                                    <li key={idx} className={`flex justify-between items-center text-xs p-1.5 border rounded mb-1 transition-colors ${isEditing ? 'bg-blue-50 border-blue-300 ring-1 ring-blue-200' : 'bg-white border-slate-200 hover:bg-slate-50'}`}>
                                        <span className="text-slate-700 flex-1 break-words mr-2">
                                            {time && <span className="font-mono font-bold text-blue-600 mr-2 bg-blue-50 px-1 rounded border border-blue-100">{time}</span>}
                                            {text}
                                        </span>
                                        <div className="flex gap-1 shrink-0">
                                            <button 
                                                onClick={() => handleStartEditSubTask(idx)} 
                                                className={`p-1 rounded transition-colors ${isEditing ? 'text-blue-600 bg-blue-100' : 'text-slate-400 hover:text-blue-500 hover:bg-blue-50'}`}
                                                title="Editar subtarea"
                                            >
                                                <Edit2 size={12}/>
                                            </button>
                                            <button 
                                                onClick={() => handleRemoveSubTask(idx)} 
                                                className="text-slate-400 hover:text-red-500 hover:bg-red-50 p-1 rounded transition-colors"
                                                title="Eliminar subtarea"
                                            >
                                                <Trash2 size={12}/>
                                            </button>
                                        </div>
                                    </li>
                                );
                            })}
                            </ul>
                        )}

                        <div className={`flex gap-2 items-end transition-all ${editingSubTaskIndex !== null ? 'bg-amber-50 p-2 rounded border border-amber-200' : ''}`}>
                            <div className="w-20 shrink-0">
                                <label className={`text-[10px] font-bold block mb-1 ${editingSubTaskIndex !== null ? 'text-amber-700' : 'text-slate-400'}`}>Hora</label>
                                <div className="flex">
                                    <input 
                                        type="time" 
                                        value={subTaskTime} 
                                        onChange={(e) => setSubTaskTime(e.target.value)}
                                        step="60"
                                        className={`w-full p-1.5 border rounded text-xs focus:outline-none focus:border-blue-500 ${editingSubTaskIndex !== null ? 'bg-white border-amber-300' : 'bg-white border-slate-300'}`}
                                    />
                                    <button onClick={setSubTaskTimeNow} className="px-1 border border-l-0 rounded-r bg-slate-100 hover:bg-slate-200 text-slate-500" title="Hora Actual">
                                        <Clock size={10} />
                                    </button>
                                </div>
                            </div>
                            <div className="flex-1">
                                <label className={`text-[10px] font-bold block mb-1 ${editingSubTaskIndex !== null ? 'text-amber-700' : 'text-slate-400'}`}>
                                    {editingSubTaskIndex !== null ? 'Editando Actividad...' : 'Nueva Actividad'}
                                </label>
                                <input 
                                    type="text" 
                                    value={currentSubTask}
                                    onChange={(e) => setCurrentSubTask(e.target.value)}
                                    onKeyDown={(e) => e.key === 'Enter' && handleAddSubTask()}
                                    placeholder={editingSubTaskIndex !== null ? "Modifica el texto..." : "Escribe y presiona Enter..."}
                                    className={`w-full p-1.5 border rounded text-xs focus:outline-none focus:border-blue-500 ${editingSubTaskIndex !== null ? 'bg-white border-amber-300' : 'bg-white border-slate-300'}`}
                                />
                            </div>
                            <div className="flex gap-1">
                                <button 
                                    onClick={handleAddSubTask}
                                    disabled={!currentSubTask.trim()}
                                    className={`h-[28px] px-2 rounded text-white disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center transition-colors ${editingSubTaskIndex !== null ? 'bg-amber-500 hover:bg-amber-600' : 'bg-slate-600 hover:bg-slate-700'}`}
                                    title={editingSubTaskIndex !== null ? "Actualizar Subtarea" : "Agregar Subtarea"}
                                >
                                    {editingSubTaskIndex !== null ? <RefreshCw size={14} /> : <Plus size={14} />}
                                </button>
                                {editingSubTaskIndex !== null && (
                                    <button 
                                        onClick={handleCancelSubTaskEdit}
                                        className="h-[28px] px-2 rounded bg-slate-200 text-slate-500 hover:bg-slate-300 flex items-center justify-center transition-colors"
                                        title="Cancelar Edición"
                                    >
                                        <X size={14} />
                                    </button>
                                )}
                            </div>
                        </div>
                        </div>

                        <button 
                        onClick={insertLogEntry}
                        disabled={!selectedResource}
                        className={`w-full py-3 text-white rounded font-medium shadow-sm transition-all flex justify-center items-center gap-2 mt-2 ${
                            editingLineIndex !== null 
                            ? 'bg-amber-600 hover:bg-amber-700' 
                            : 'bg-slate-800 hover:bg-slate-700 disabled:bg-slate-300 disabled:text-slate-500'
                        }`}
                        >
                        {editingLineIndex !== null ? (
                            <><RefreshCw size={16} /> Actualizar Entrada</>
                        ) : (
                            <><Save size={16} /> Cargar en Bitácora</>
                        )}
                        </button>
                    </div>
                </div>
              )}
          </div>
        </section>
      </main>
    </div>
  );
};

export default App;