import { Routes, Route } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'
import { SidebarLayout } from './components/layout/SidebarLayout'
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'
import EntityPage from './pages/EntityPage'
import Reportes from './pages/Reportes'
import Calendario from './pages/Calendario'
import Estadoproyecto from './pages/Estadoproyecto'
import Sistema from './pages/Sistema'
import PrivateRoute from './components/auth/PrivateRoute'
import { ThemeProvider } from './contexts/ThemeContext'

function App() {
  return (
    <ThemeProvider>
      <div className="App">
      {/* Global Theme CSS */}
      <style>{`
        /* Light Theme Variables */
        :root {
          /* Light Theme - Clean Professional Palette */
          --bg-primary: #ffffff;       /* Pure white background */
          --bg-secondary: #f8fafc;     /* Very light gray */
          --bg-tertiary: #f1f5f9;      /* Light gray */
          --bg-card: #ffffff;          /* White card backgrounds */
          --bg-hover: #f1f5f9;         /* Light hover states */
          --bg-active: #4f46e5;        /* Indigo blue accent */
          --bg-input: #ffffff;         /* White form inputs */
          --bg-border: #e2e8f0;        /* Light borders */

          /* Text Colors */
          --text-primary: #1e293b;      /* Dark slate text */
          --text-secondary: #475569;   /* Medium slate */
          --text-muted: #64748b;       /* Muted slate */
          --text-accent: #4f46e5;      /* Indigo accent */

          /* Border Colors */
          --border-primary: #e2e8f0;   /* Light gray borders */
          --border-secondary: #cbd5e1; /* Medium light borders */
          --border-focus: #4f46e5;     /* Indigo focus */

          /* Shadow Colors */
          --shadow-primary: rgba(0, 0, 0, 0.1);
          --shadow-secondary: rgba(0, 0, 0, 0.05);
          --shadow-accent: rgba(79, 70, 229, 0.2);

          /* Status Colors */
          --success: #10b981;          /* Green for success */
          --warning: #f59e0b;          /* Amber for warning */
          --error: #ef4444;            /* Red for error */
          --info: #4f46e5;             /* Indigo for info */

          /* Transitions */
          --transition-fast: 0.15s cubic-bezier(0.4, 0, 0.2, 1);
          --transition-normal: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* Dark Theme Variables */
        .dark-theme {
          /* AdGuard DNS Inspired Color Palette: Clean, Professional Dark Theme */
          --bg-primary: #0a0a0a;      /* Deep black background */
          --bg-secondary: #1a1a1a;    /* Dark gray */
          --bg-tertiary: #2a2a2a;     /* Medium dark gray */
          --bg-card: #1a1a1a;         /* Card backgrounds */
          --bg-hover: #2a2a2a;        /* Hover states */
          --bg-active: #4f46e5;       /* Indigo blue accent */
          --bg-input: #1a1a1a;        /* Form inputs */
          --bg-border: #2a2a2a;       /* Borders */

          /* Text Colors */
          --text-primary: #ffffff;     /* Pure white text */
          --text-secondary: #d1d5db;   /* Light gray */
          --text-muted: #9ca3af;      /* Muted gray */
          --text-accent: #4f46e5;     /* Indigo accent */

          /* Border Colors */
          --border-primary: #374151;   /* Gray-700 */
          --border-secondary: #4b5563;  /* Gray-600 */
          --border-focus: #4f46e5;      /* Indigo focus */

          /* Shadow Colors */
          --shadow-primary: rgba(0, 0, 0, 0.5);
          --shadow-secondary: rgba(0, 0, 0, 0.3);
          --shadow-accent: rgba(79, 70, 229, 0.4);
        }

        /* Global Theme Application */
        body {
          background: var(--bg-primary) !important;
          color: var(--text-primary) !important;
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
          transition: background-color var(--transition-normal), color var(--transition-normal);
        }

        /* Cards and Containers */
        .card {
          background: var(--bg-card) !important;
          border: 1px solid var(--border-primary) !important;
          color: var(--text-primary) !important;
        }

        .card-header {
          background: var(--bg-tertiary) !important;
          border-bottom: 1px solid var(--border-primary) !important;
          color: var(--text-primary) !important;
        }

        /* Tables */
        .table {
          color: var(--text-primary) !important;
        }

        .table thead th {
          background: var(--bg-tertiary) !important;
          border-color: var(--border-primary) !important;
          color: var(--text-secondary) !important;
        }

        .table tbody tr {
          background: var(--bg-secondary) !important;
          border-color: var(--border-primary) !important;
        }

        .table tbody tr:nth-child(even) {
          background: var(--bg-tertiary) !important;
        }

        .table tbody tr:hover {
          background: var(--bg-hover) !important;
        }

        .table tbody td {
          border-color: var(--border-primary) !important;
          color: var(--text-primary) !important;
        }

        /* Forms */
        .form-control {
          background: var(--bg-input) !important;
          border: 1px solid var(--border-primary) !important;
          color: var(--text-primary) !important;
        }

        .form-control:focus {
          background: var(--bg-input) !important;
          border-color: var(--border-focus) !important;
          color: var(--text-primary) !important;
          box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, 0.25) !important;
        }

        .form-label {
          color: var(--text-secondary) !important;
        }

        .form-select {
          background: var(--bg-input) !important;
          border: 1px solid var(--border-primary) !important;
          color: var(--text-primary) !important;
        }

        /* Buttons */
        .btn-primary {
          background: var(--bg-active) !important;
          border-color: var(--bg-active) !important;
          color: white !important;
        }

        .btn-primary:hover {
          background: #2563eb !important;
          border-color: #2563eb !important;
        }

        .btn-secondary {
          background: var(--bg-tertiary) !important;
          border-color: var(--border-primary) !important;
          color: var(--text-primary) !important;
        }

        .btn-outline-primary {
          border-color: var(--bg-active) !important;
          color: var(--bg-active) !important;
        }

        .btn-outline-primary:hover {
          background: var(--bg-active) !important;
          border-color: var(--bg-active) !important;
          color: white !important;
        }

        /* Alerts and Notifications */
        .alert-success {
          background: rgba(16, 185, 129, 0.1) !important;
          border-color: var(--success) !important;
          color: var(--success) !important;
        }

        .alert-warning {
          background: rgba(245, 158, 11, 0.1) !important;
          border-color: var(--warning) !important;
          color: var(--warning) !important;
        }

        .alert-danger {
          background: rgba(239, 68, 68, 0.1) !important;
          border-color: var(--error) !important;
          color: var(--error) !important;
        }

        .alert-info {
          background: rgba(59, 130, 246, 0.1) !important;
          border-color: var(--info) !important;
          color: var(--info) !important;
        }

        /* Badges */
        .badge {
          font-weight: 500 !important;
        }

        .bg-success {
          background: var(--success) !important;
        }

        .bg-warning {
          background: var(--warning) !important;
        }

        .bg-danger {
          background: var(--error) !important;
        }

        .bg-info {
          background: var(--info) !important;
        }

        .bg-primary {
          background: var(--bg-active) !important;
        }

        .bg-secondary {
          background: var(--bg-tertiary) !important;
        }

        /* Pagination */
        .pagination .page-link {
          background: var(--bg-secondary) !important;
          border-color: var(--border-primary) !important;
          color: var(--text-primary) !important;
        }

        .pagination .page-link:hover {
          background: var(--bg-hover) !important;
          border-color: var(--border-secondary) !important;
          color: var(--text-primary) !important;
        }

        .pagination .page-item.active .page-link {
          background: var(--bg-active) !important;
          border-color: var(--bg-active) !important;
        }

        /* Dropdowns */
        .dropdown-menu {
          background: var(--bg-card) !important;
          border: 1px solid var(--border-primary) !important;
          box-shadow: 0 10px 15px -3px var(--shadow-primary), 0 4px 6px -2px var(--shadow-secondary) !important;
        }

        .dropdown-item {
          color: var(--text-primary) !important;
        }

        .dropdown-item:hover {
          background: var(--bg-hover) !important;
          color: var(--text-primary) !important;
        }

        /* Modals */
        .modal-content {
          background: var(--bg-card) !important;
          border: 1px solid var(--border-primary) !important;
          color: var(--text-primary) !important;
        }

        .modal-header {
          border-bottom: 1px solid var(--border-primary) !important;
        }

        .modal-footer {
          border-top: 1px solid var(--border-primary) !important;
        }

        /* Bootstrap Utilities Override */
        .text-primary { color: var(--text-accent) !important; }
        .text-secondary { color: var(--text-secondary) !important; }
        .text-muted { color: var(--text-muted) !important; }
        .text-dark { color: #1f2937 !important; }
        .text-light { color: var(--text-secondary) !important; }

        .bg-light { background: var(--bg-tertiary) !important; }
        .bg-white { background: var(--bg-secondary) !important; }

        .border { border-color: var(--border-primary) !important; }
        .border-top { border-top-color: var(--border-primary) !important; }
        .border-bottom { border-bottom-color: var(--border-primary) !important; }
        .border-left { border-left-color: var(--border-primary) !important; }
        .border-right { border-right-color: var(--border-primary) !important; }

        /* Links */
        a {
          color: var(--text-accent) !important;
        }

        a:hover {
          color: #93c5fd !important;
        }

        /* Focus states for accessibility */
        .form-control:focus,
        .form-select:focus,
        .btn:focus {
          outline: 2px solid var(--border-focus) !important;
          outline-offset: 2px !important;
        }

        /* Scrollbar styling for dark theme */
        ::-webkit-scrollbar {
          width: 8px;
          height: 8px;
        }

        ::-webkit-scrollbar-track {
          background: var(--bg-tertiary);
        }

        ::-webkit-scrollbar-thumb {
          background: var(--bg-border);
          border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
          background: var(--border-secondary);
        }

        /* Loading states */
        .spinner-border {
          border-color: var(--bg-active);
          border-right-color: transparent;
        }

        /* Empty states */
        .empty-state {
          color: var(--text-muted);
        }

        .empty-state i {
          color: var(--text-muted);
          opacity: 0.5;
        }

        /* Specific component overrides */
        .sidebar-main-content {
          background: var(--bg-primary);
        }

        .entity-table {
          background: var(--bg-card);
        }

        .entity-table thead th {
          background: var(--bg-tertiary) !important;
          border-color: var(--border-primary) !important;
        }

        .entity-table tbody td {
          background: var(--bg-secondary);
          border-color: var(--border-primary);
        }

        .entity-table tbody tr:nth-child(even) td {
          background: var(--bg-tertiary);
        }

        .entity-table tbody tr:hover td {
          background: var(--bg-hover);
        }

        /* Stats cards */
        .stats-card {
          background: var(--bg-card);
          border: 1px solid var(--border-primary);
        }

        /* Filters section */
        .filters-section {
          background: var(--bg-secondary) !important;
          border: 1px solid var(--border-primary) !important;
        }

        /* Form sections */
        .form-section .card {
          background: var(--bg-card) !important;
          border: 1px solid var(--border-primary) !important;
        }

        .form-section .card-header {
          background: var(--bg-tertiary) !important;
          border-bottom: 1px solid var(--border-primary) !important;
        }
      `}</style>

      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/*" element={
          <PrivateRoute>
            <SidebarLayout>
              <Routes>
                <Route path="/" element={<Dashboard />} />
                <Route path="/dashboard" element={<Dashboard />} />
                <Route path="/tecnicos" element={<EntityPage />} />
                <Route path="/tareas" element={<EntityPage />} />
                <Route path="/reportes" element={<Reportes />} />
                <Route path="/usuarios" element={<EntityPage />} />
                <Route path="/calendario" element={<Calendario />} />
                <Route path="/recursos" element={<EntityPage />} />
                <Route path="/sistema" element={<Sistema />} />
                <Route path="/estadoproyecto" element={<Estadoproyecto />} />
                {/* Dynamic entity routes */}
                <Route path="/entity/:entityKey" element={<EntityPage />} />
              </Routes>
            </SidebarLayout>
          </PrivateRoute>
        } />
      </Routes>
      <Toaster
        position="top-right"
        toastOptions={{
          duration: 4000,
          style: {
            background: '#1e293b',
            color: '#f8fafc',
            border: '1px solid #334155',
          },
        }}
      />
      </div>
    </ThemeProvider>
  )
}

export default App