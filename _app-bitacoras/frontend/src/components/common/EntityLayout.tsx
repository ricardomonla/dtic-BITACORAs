import React from 'react'

interface StatCard {
  title: string
  value: number
  subtitle: string
  color: string
}

interface EntityLayoutProps {
  title: string
  subtitle: string
  icon: string
  stats: StatCard[]
  children: React.ReactNode
  className?: string
}

export const EntityLayout = ({
  title,
  subtitle,
  icon,
  stats,
  children,
  className = ''
}: EntityLayoutProps) => {
  return (
    <div className={`container mt-4 scroll-smooth ${className}`}>
      {/* Header */}
      <div className="row mb-4">
        <div className="col-12">
          <div className="d-flex align-items-center mb-3">
            <i className={`fas ${icon} fa-2x text-primary me-3`}></i>
            <div>
              <h1 className="h3 mb-0">{title}</h1>
              <p className="text-muted mb-0">{subtitle}</p>
            </div>
          </div>
        </div>
      </div>

      {/* Statistics Cards */}
      <div className="row mb-4">
        {stats.map((stat, index) => (
          <div key={index} className="col-md-3 mb-3">
            <div className="card h-100">
              <div className="card-header">
                <i className={`fas fa-chart-line text-${stat.color} me-2`}></i>
                {stat.title}
              </div>
              <div className="card-body text-center">
                <div className={`display-4 text-${stat.color} mb-2 fw-bold`}>
                  {stat.value}
                </div>
                <small className="text-muted">{stat.subtitle}</small>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Main Content */}
      {children}
    </div>
  )
}