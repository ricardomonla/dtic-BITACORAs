import React, { useState, useEffect } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { useAuthStore } from '../../stores/authStore'

interface SidebarProps {
  onToggle?: (collapsed: boolean) => void
}

const Sidebar = ({ onToggle }: SidebarProps) => {
  const location = useLocation()
  const { user, logout } = useAuthStore()
  const [isCollapsed, setIsCollapsed] = useState(false)

  const handleLogout = () => {
    logout()
    // Navigate to login will be handled by the auth store
  }

  const isActive = (path: string) => {
    return location.pathname === path
  }

  // Load collapsed state from localStorage on mount
  useEffect(() => {
    const savedState = localStorage.getItem('sidebarCollapsed')
    if (savedState === 'true') {
      setIsCollapsed(true)
    }
  }, [])

  // Save collapsed state to localStorage
  const toggleSidebar = () => {
    const newState = !isCollapsed
    setIsCollapsed(newState)
    localStorage.setItem('sidebarCollapsed', newState.toString())
    if (onToggle) {
      onToggle(newState)
    }
  }

  const navItems = [
    { path: '/dashboard', icon: 'fas fa-tachometer-alt', label: 'Dashboard', color: 'text-primary' },
    { path: '/calendario', icon: 'fas fa-calendar', label: 'Calendario', color: 'text-secondary' },
    { path: '/recursos', icon: 'fas fa-server', label: 'Recursos', color: 'text-info' },
    { path: '/tareas', icon: 'fas fa-tasks', label: 'Tareas', color: 'text-warning' },
    { path: '/tecnicos', icon: 'fas fa-users', label: 'Técnicos', color: 'text-success' },
    ...(user?.role === 'admin' ? [
      { path: '/usuarios', icon: 'fas fa-user-cog', label: 'Usuarios', color: 'text-dark' },
      { path: '/sistema', icon: 'fas fa-cogs', label: 'Sistema', color: 'text-secondary' }
    ] : []),
    { path: '/reportes', icon: 'fas fa-chart-bar', label: 'Reportes', color: 'text-danger' }
  ]

  return (
    <>
      {/* Modern Material Design 3 Inspired Sidebar CSS */}
      <style>{`
        .sidebar-modern {
          width: 280px;
          background: var(--bg-secondary);
          color: var(--text-primary);
          transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
          position: fixed;
          top: 0;
          left: 0;
          height: 100vh;
          z-index: 1000;
          box-shadow: 0 4px 6px -1px var(--shadow-primary), 0 2px 4px -1px var(--shadow-secondary);
          border-right: 1px solid var(--border-primary);
          overflow-y: auto;
          overflow-x: hidden;
        }

        .sidebar-modern.collapsed {
          width: 72px;
        }

        .sidebar-header-modern {
          padding: 24px 20px 16px;
          border-bottom: 1px solid var(--border-primary);
          display: flex;
          align-items: center;
          justify-content: space-between;
          min-height: 80px;
          background: var(--bg-tertiary);
        }

        .sidebar-modern.collapsed .sidebar-header-modern {
          justify-content: center;
          padding: 24px 12px 16px;
        }

        .sidebar-brand-modern {
          display: flex;
          flex-direction: column;
          align-items: center;
          text-align: center;
          font-weight: 700;
          font-size: 1.1rem;
          color: #1f2937;
        }

        .sidebar-modern.collapsed .brand-text-modern {
          display: none;
        }

        .sidebar-toggle-modern {
          background: var(--bg-tertiary);
          border: 1px solid var(--border-primary);
          color: var(--text-secondary);
          font-size: 1.1rem;
          cursor: pointer;
          padding: 8px;
          border-radius: 8px;
          transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
          display: flex;
          align-items: center;
          justify-content: center;
          box-shadow: 0 1px 3px 0 var(--shadow-primary), 0 1px 2px 0 var(--shadow-secondary);
        }

        .sidebar-toggle-modern:hover {
          background: var(--bg-hover);
          color: var(--text-primary);
          transform: scale(1.05);
          box-shadow: 0 4px 6px -1px var(--shadow-primary), 0 2px 4px -1px var(--shadow-secondary);
        }

        .sidebar-nav-modern {
          padding: 16px 0;
        }

        .sidebar-link-modern {
          display: flex;
          flex-direction: column;
          align-items: center;
          padding: 16px 20px;
          color: var(--text-secondary);
          text-decoration: none;
          transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
          border-radius: 12px;
          margin: 4px 12px;
          text-align: center;
          position: relative;
          font-weight: 500;
          font-size: 0.875rem;
        }

        .sidebar-link-modern:hover {
          background: var(--bg-hover);
          color: var(--text-primary);
          transform: translateY(-1px);
          box-shadow: 0 2px 4px -1px var(--shadow-primary), 0 1px 2px -1px var(--shadow-secondary);
        }

        .sidebar-link-modern.active {
          background: var(--bg-active);
          color: white;
          box-shadow: 0 4px 6px -1px var(--shadow-accent), 0 2px 4px -1px rgba(59, 130, 246, 0.2);
        }

        .sidebar-link-modern.active:hover {
          background: #2563eb;
        }

        .sidebar-link-modern i {
          font-size: 1.5rem;
          margin-bottom: 6px;
          transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sidebar-link-modern:hover i,
        .sidebar-link-modern.active i {
          transform: scale(1.1);
        }

        .sidebar-modern.collapsed .link-text-modern {
          display: none;
        }


        /* Modern dark scrollbar */
        .sidebar-modern::-webkit-scrollbar {
          width: 6px;
        }

        .sidebar-modern::-webkit-scrollbar-track {
          background: var(--bg-tertiary);
        }

        .sidebar-modern::-webkit-scrollbar-thumb {
          background: var(--border-secondary);
          border-radius: 3px;
        }

        .sidebar-modern::-webkit-scrollbar-thumb:hover {
          background: var(--text-muted);
        }

        /* Mobile responsive */
        @media (max-width: 768px) {
          .sidebar-modern {
            transform: translateX(-100%);
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 4px 0 6px -1px rgba(0, 0, 0, 0.1), 2px 0 4px -1px rgba(0, 0, 0, 0.06);
          }

          .sidebar-modern.mobile-open {
            transform: translateX(0);
          }

          .sidebar-overlay-modern {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0,0,0,0.5);
            z-index: 999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            backdrop-filter: blur(4px);
          }

          .sidebar-overlay-modern.active {
            opacity: 1;
            visibility: visible;
          }
        }

        /* Focus states for accessibility */
        .sidebar-link-modern:focus,
        .sidebar-toggle-modern:focus {
          outline: 2px solid #3b82f6;
          outline-offset: 2px;
        }
      `}</style>

      {/* Modern Material Design Sidebar */}
      <aside className={`sidebar-modern ${isCollapsed ? 'collapsed' : ''}`}>
        {/* Header */}
        <div className="sidebar-header-modern">
          <button
            className="sidebar-toggle-modern"
            onClick={toggleSidebar}
            title={isCollapsed ? 'Expandir menú' : 'Colapsar menú'}
            aria-label={isCollapsed ? 'Expandir menú' : 'Colapsar menú'}
          >
            <i className={`fas ${isCollapsed ? 'fa-chevron-right' : 'fa-chevron-left'}`}></i>
          </button>
          <div className="sidebar-brand-modern">
            <i className="fas fa-cogs text-primary" style={{ fontSize: '1.8rem', marginBottom: '4px' }}></i>
            <span className="brand-text-modern fw-bold">DTIC</span>
          </div>
        </div>

        {/* Navigation */}
        <nav className="sidebar-nav-modern" role="navigation" aria-label="Navegación principal">
          {navItems.map((item) => (
            <Link
              key={item.path}
              to={item.path}
              className={`sidebar-link-modern ${isActive(item.path) ? 'active' : ''}`}
              title={isCollapsed ? item.label : ''}
              aria-label={item.label}
            >
              <i className={item.icon} aria-hidden="true"></i>
              <span className="link-text-modern">{item.label}</span>
            </Link>
          ))}
        </nav>

      </aside>
    </>
  )
}

export default Sidebar