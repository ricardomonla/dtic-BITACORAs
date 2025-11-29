# Authentication

## Table of Contents
- [English Version](#english-version)
  - [Description](#description)
  - [Key Features](#key-features)
  - [Module Interrelationships](#module-interrelationships)
  - [Improvement Proposals](#improvement-proposals)
- [Versión en Español](#versión-en-español)
  - [Descripción](#descripción)
  - [Características Principales](#características-principales)
  - [Interrelaciones del Módulo](#interrelaciones-del-módulo)
  - [Propuestas de Mejora](#propuestas-de-mejora)

---

## English Version

### Description
The Authentication module handles user login, registration, session management, and access control for the DTIC Bitácoras system. It implements JWT-based authentication with role-based permissions, providing secure access to the application's features based on user roles (admin, technician, viewer).

### Key Features
- User login with email and password validation
- JWT token generation and verification (8-hour expiration)
- Password hashing using bcrypt with salt rounds
- Role-based access control (admin > technician > viewer)
- Token refresh functionality
- User registration (admin-only)
- Session persistence with local storage
- Automatic logout on token expiration
- Audit logging for authentication events
- Protected routes with automatic redirects

### Module Interrelationships
- **All Modules**: Provides authentication middleware and user context to all other system modules
- **Database**: Queries `dtic.tecnicos` table for user credentials and role information
- **Frontend Routing**: Integrates with React Router via PrivateRoute component
- **Audit System**: Logs authentication actions to `dtic.audit_log` table
- **UI Components**: Supplies user information to navigation and profile components

### Improvement Proposals
- Implement rate limiting on login attempts to prevent brute force attacks
- Add two-factor authentication (2FA) for enhanced security
- Implement password strength requirements and complexity validation
- Add account lockout mechanism after multiple failed attempts
- Enhance token refresh with sliding expiration
- Add OAuth integration for single sign-on capabilities
- Implement session management with concurrent session limits
- Add password reset functionality via email
- Improve error messages to prevent user enumeration attacks
- Add biometric authentication support for mobile devices

---

## Versión en Español

### Descripción
El módulo de Autenticación maneja el inicio de sesión de usuarios, registro, gestión de sesiones y control de acceso para el sistema DTIC Bitácoras. Implementa autenticación basada en JWT con permisos basados en roles, proporcionando acceso seguro a las características de la aplicación según los roles de usuario (admin, technician, viewer).

### Características Principales
- Inicio de sesión de usuario con validación de email y contraseña
- Generación y verificación de tokens JWT (expiración de 8 horas)
- Hashing de contraseñas usando bcrypt con rondas de sal
- Control de acceso basado en roles (admin > technician > viewer)
- Funcionalidad de refresco de tokens
- Registro de usuarios (solo admin)
- Persistencia de sesión con almacenamiento local
- Cierre de sesión automático al expirar el token
- Registro de auditoría para eventos de autenticación
- Rutas protegidas con redirecciones automáticas

### Interrelaciones del Módulo
- **Todos los Módulos**: Proporciona middleware de autenticación y contexto de usuario a todos los demás módulos del sistema
- **Base de Datos**: Consulta la tabla `dtic.tecnicos` para credenciales y información de roles de usuario
- **Enrutamiento Frontend**: Se integra con React Router mediante el componente PrivateRoute
- **Sistema de Auditoría**: Registra acciones de autenticación en la tabla `dtic.audit_log`
- **Componentes UI**: Suministra información de usuario a componentes de navegación y perfil

### Propuestas de Mejora
- Implementar limitación de tasa en intentos de inicio de sesión para prevenir ataques de fuerza bruta
- Agregar autenticación de dos factores (2FA) para mayor seguridad
- Implementar requisitos de fortaleza de contraseña y validación de complejidad
- Agregar mecanismo de bloqueo de cuenta después de múltiples intentos fallidos
- Mejorar el refresco de tokens con expiración deslizante
- Agregar integración OAuth para inicio de sesión único
- Implementar gestión de sesiones con límites de sesiones concurrentes
- Agregar funcionalidad de restablecimiento de contraseña vía email
- Mejorar mensajes de error para prevenir enumeración de usuarios
- Agregar soporte de autenticación biométrica para dispositivos móviles