import React, { useState, useEffect } from 'react'
import Sidebar from './Sidebar'
import { useAuthStore } from '../../stores/authStore'
import { useTheme } from '../../contexts/ThemeContext'

interface SidebarLayoutProps {
  children: React.ReactNode
  className?: string
}

export const SidebarLayout = ({ children, className = '' }: SidebarLayoutProps) => {
  const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(false)
  const [isUserMenuOpen, setIsUserMenuOpen] = useState(false)
  const { user, logout } = useAuthStore()
  const { theme, toggleTheme } = useTheme()

  const handleLogout = () => {
    logout()
    setIsUserMenuOpen(false)
  }

  // Load initial collapsed state from localStorage
  useEffect(() => {
    const savedState = localStorage.getItem('sidebarCollapsed')
    if (savedState === 'true') {
      setIsSidebarCollapsed(true)
    }
  }, [])

  const handleSidebarToggle = (collapsed: boolean) => {
    setIsSidebarCollapsed(collapsed)
  }

  // Close user menu when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as Element
      if (!target.closest('.floating-user-menu')) {
        setIsUserMenuOpen(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  return (
    <div className={`sidebar-layout ${isSidebarCollapsed ? 'has-collapsed-sidebar' : ''} ${className}`}>
      {/* Custom CSS for sidebar layout */}
      <style>{`
        .sidebar-layout {
          display: flex;
          min-height: 100vh;
          background: var(--bg-primary);
        }

        .sidebar-main-content {
          flex: 1;
          margin-left: 280px;
          transition: margin-left 0.3s ease;
          display: flex;
          flex-direction: column;
        }

        .sidebar-layout.has-collapsed-sidebar .sidebar-main-content {
          margin-left: 70px;
        }

        /* Floating User Menu Styles */
        .floating-user-menu {
          position: fixed;
          top: 20px;
          right: 20px;
          z-index: 1050;
        }

        .floating-user-avatar {
          width: 48px;
          height: 48px;
          border-radius: 50%;
          background: var(--bg-active);
          border: 3px solid var(--bg-secondary);
          display: flex;
          align-items: center;
          justify-content: center;
          color: white;
          font-weight: 700;
          font-size: 1.2rem;
          cursor: pointer;
          transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
          box-shadow: 0 4px 12px var(--shadow-primary);
        }

        .floating-user-avatar:hover {
          transform: scale(1.1);
          box-shadow: 0 6px 20px var(--shadow-accent);
          border-color: var(--bg-active);
        }

        .floating-user-avatar.active {
          border-color: var(--bg-active);
          box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
        }

        .floating-user-dropdown {
          position: absolute;
          top: 60px;
          right: 0;
          width: 280px;
          background: var(--bg-card);
          border: 1px solid var(--border-primary);
          border-radius: 16px;
          box-shadow: 0 20px 25px -5px var(--shadow-primary), 0 10px 10px -5px var(--shadow-secondary);
          opacity: 0;
          visibility: hidden;
          transform: translateY(-10px) scale(0.95);
          transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
          z-index: 1060;
        }

        .floating-user-dropdown.open {
          opacity: 1;
          visibility: visible;
          transform: translateY(0) scale(1);
        }

        .user-dropdown-header {
          padding: 20px;
          border-bottom: 1px solid var(--border-primary);
          background: var(--bg-tertiary);
          border-radius: 16px 16px 0 0;
        }

        .user-avatar-large {
          width: 64px;
          height: 64px;
          border-radius: 50%;
          background: var(--bg-active);
          display: flex;
          align-items: center;
          justify-content: center;
          color: white;
          font-weight: 700;
          font-size: 1.5rem;
          margin: 0 auto 12px;
          border: 3px solid var(--bg-secondary);
        }

        .user-full-info {
          text-align: center;
        }

        .user-full-name {
          font-weight: 700;
          font-size: 1.1rem;
          color: var(--text-primary);
          margin-bottom: 4px;
        }

        .user-full-role {
          font-size: 0.875rem;
          color: var(--text-secondary);
          background: var(--bg-active);
          padding: 4px 12px;
          border-radius: 20px;
          display: inline-block;
          font-weight: 500;
        }

        .user-dropdown-body {
          padding: 8px 0;
        }

        .user-menu-item {
          display: flex;
          align-items: center;
          gap: 12px;
          padding: 12px 20px;
          color: var(--text-primary);
          text-decoration: none;
          transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
          border-radius: 8px;
          margin: 4px 12px;
        }

        .user-menu-item:hover {
          background: var(--bg-hover);
          transform: translateX(4px);
        }

        .user-menu-item i {
          font-size: 1.1rem;
          width: 20px;
          color: var(--text-secondary);
        }

        .user-menu-item.logout {
          color: var(--error);
          border-top: 1px solid var(--border-primary);
          margin-top: 8px;
          padding-top: 16px;
        }

        .user-menu-item.logout:hover {
          background: rgba(239, 68, 68, 0.1);
        }

        .user-menu-item.logout i {
          color: var(--error);
        }

        /* Content adjustment - no top margin needed since no header */
        .sidebar-content-wrapper {
          flex: 1;
          overflow-y: auto;
        }

        /* Mobile responsiveness */
        @media (max-width: 768px) {
          .sidebar-main-content {
            margin-left: 0;
          }

          .sidebar-layout.has-collapsed-sidebar .sidebar-main-content {
            margin-left: 0;
          }

          .sidebar-top-header {
            left: 0;
            right: 0;
            padding: 0 20px;
          }

          .sidebar-layout.has-collapsed-sidebar .sidebar-top-header {
            left: 0;
          }
        }

        .sidebar-top-header {
          background: white;
          padding: 15px 30px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          border-bottom: 1px solid #e9ecef;
          display: flex;
          justify-content: space-between;
          align-items: center;
          min-height: 70px;
        }

        .sidebar-page-title {
          margin: 0;
          font-size: 1.5rem;
          font-weight: 600;
          color: #495057;
        }

        .sidebar-page-subtitle {
          margin: 0;
          font-size: 1rem;
          color: #6c757d;
          font-weight: 400;
        }

        .sidebar-page-content {
          flex: 1;
          padding: 30px;
          overflow-y: auto;
        }

        .sidebar-breadcrumb {
          background: white;
          padding: 10px 30px;
          border-bottom: 1px solid #e9ecef;
          font-size: 0.875rem;
        }

        .sidebar-breadcrumb a {
          color: #667eea;
          text-decoration: none;
        }

        .sidebar-breadcrumb a:hover {
          text-decoration: underline;
        }

        .sidebar-breadcrumb .current {
          color: #6c757d;
        }

        /* Mobile responsiveness */
        @media (max-width: 768px) {
          .sidebar-main-content {
            margin-left: 0;
          }

          .sidebar-layout.has-collapsed-sidebar .sidebar-main-content {
            margin-left: 0;
          }

          .sidebar-page-content {
            padding: 20px 15px;
          }

          .sidebar-top-header {
            padding: 15px 20px;
          }
        }

        /* Animation for content when sidebar collapses */
        .sidebar-content-wrapper {
          transition: all 0.3s ease;
        }

        /* Ensure proper spacing for fixed sidebar */
        .sidebar-layout .sidebar-main-content {
          width: calc(100% - 280px);
        }

        .sidebar-layout.has-collapsed-sidebar .sidebar-main-content {
          width: calc(100% - 70px);
        }

        @media (max-width: 768px) {
          .sidebar-layout .sidebar-main-content {
            width: 100%;
          }

          .sidebar-layout.has-collapsed-sidebar .sidebar-main-content {
            width: 100%;
          }
        }

        /* Application Header Styles */
        .app-header {
          position: fixed;
          top: 80px;
          left: 280px;
          right: 0;
          height: 70px;
          background: var(--bg-card);
          border-bottom: 1px solid var(--border-primary);
          box-shadow: 0 2px 4px var(--shadow-primary);
          z-index: 1020;
          transition: left 0.3s ease;
        }

        .sidebar-layout.has-collapsed-sidebar .app-header {
          left: 70px;
        }

        .app-header-content {
          height: 100%;
          display: flex;
          align-items: center;
          padding: 0 30px;
        }

        .app-brand {
          display: flex;
          align-items: center;
          gap: 15px;
        }

        .app-logo {
          font-size: 2rem;
          color: var(--bg-active);
        }

        .app-info {
          display: flex;
          flex-direction: column;
        }

        .app-name {
          font-size: 1.5rem;
          font-weight: 700;
          color: var(--text-primary);
          margin: 0;
          line-height: 1.2;
        }

        .app-version {
          font-size: 0.875rem;
          color: var(--text-secondary);
          background: var(--bg-active);
          color: white;
          padding: 2px 8px;
          border-radius: 12px;
          font-weight: 500;
          display: inline-block;
          margin-top: 2px;
        }

        /* Application Footer Styles */
        .app-footer {
          position: fixed;
          bottom: 0;
          left: 280px;
          right: 0;
          height: 50px;
          background: var(--bg-card);
          border-top: 1px solid var(--border-primary);
          z-index: 1020;
          transition: left 0.3s ease;
        }

        .sidebar-layout.has-collapsed-sidebar .app-footer {
          left: 70px;
        }

        .app-footer-content {
          height: 100%;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 0 30px;
        }

        .footer-info {
          display: flex;
          align-items: center;
          justify-content: space-between;
          width: 100%;
          font-size: 0.875rem;
          color: var(--text-muted);
        }

        .footer-text {
          display: flex;
          align-items: center;
        }

        .footer-version {
          font-weight: 500;
          color: var(--text-secondary);
        }

        /* Adjust main content for header and footer */
        .sidebar-main-content {
          margin-top: 150px;
          margin-bottom: 50px;
          min-height: calc(100vh - 200px);
        }

        /* Mobile responsiveness for header and footer */
        @media (max-width: 768px) {
          .app-header {
            top: 80px;
            left: 0;
            height: 60px;
          }

          .sidebar-layout.has-collapsed-sidebar .app-header {
            left: 0;
          }

          .app-header-content {
            padding: 0 20px;
          }

          .app-name {
            font-size: 1.25rem;
          }

          .app-logo {
            font-size: 1.5rem;
          }

          .app-footer {
            left: 0;
            height: 45px;
          }

          .sidebar-layout.has-collapsed-sidebar .app-footer {
            left: 0;
          }

          .app-footer-content {
            padding: 0 20px;
          }

          .footer-info {
            flex-direction: column;
            gap: 5px;
            text-align: center;
          }

          .sidebar-main-content {
            margin-top: 140px;
            margin-bottom: 45px;
            min-height: calc(100vh - 185px);
          }
        }
      `}</style>

      <Sidebar onToggle={handleSidebarToggle} />

      {/* Application Header */}
      <header className="app-header">
        <div className="app-header-content">
          <div className="app-brand">
            <i className="fas fa-cogs app-logo"></i>
            <div className="app-info">
              <h1 className="app-name">DTIC Bitácoras</h1>
              <span className="app-version">v{(import.meta as any).env.VERSION}</span>
            </div>
          </div>
        </div>
      </header>

      {/* Floating User Menu */}
      <div className="floating-user-menu">
        <div
          className={`floating-user-avatar ${isUserMenuOpen ? 'active' : ''}`}
          onClick={() => setIsUserMenuOpen(!isUserMenuOpen)}
          title="Menú de usuario"
        >
          {user?.first_name?.charAt(0)?.toUpperCase() || 'U'}
        </div>

        <div className={`floating-user-dropdown ${isUserMenuOpen ? 'open' : ''}`}>
          <div className="user-dropdown-header">
            <div className="user-avatar-large">
              {user?.first_name?.charAt(0)?.toUpperCase() || 'U'}
            </div>
            <div className="user-full-info">
              <div className="user-full-name">{user?.first_name}</div>
              <div className="user-full-role">
                {user?.role === 'admin' ? 'Administrador' : 'Usuario'}
              </div>
            </div>
          </div>

          <div className="user-dropdown-body">
            <a href="/perfil" className="user-menu-item" onClick={() => setIsUserMenuOpen(false)}>
              <i className="fas fa-user-edit"></i>
              <span>Mi Perfil</span>
            </a>
            <button
              className="user-menu-item"
              onClick={() => {
                toggleTheme()
                setIsUserMenuOpen(false)
              }}
            >
              <i className={`fas ${theme === 'dark' ? 'fa-sun' : 'fa-moon'}`}></i>
              <span>{theme === 'dark' ? 'Tema Claro' : 'Tema Oscuro'}</span>
            </button>
            <button
              className="user-menu-item logout"
              onClick={handleLogout}
            >
              <i className="fas fa-sign-out-alt"></i>
              <span>Cerrar Sesión</span>
            </button>
          </div>
        </div>
      </div>

      <main className="sidebar-main-content">
        <div className="sidebar-content-wrapper">
          {children}
        </div>
      </main>

      {/* Application Footer */}
      <footer className="app-footer">
        <div className="app-footer-content">
          <div className="footer-info">
            <span className="footer-text">
              <i className="fas fa-university me-2"></i>
              DTIC - Universidad Tecnológica Nacional
            </span>
            <span className="footer-version">
              Versión {(import.meta as any).env.VERSION}
            </span>
          </div>
        </div>
      </footer>
    </div>
  )
}