FROM node:18-alpine

# Instalar Docker CLI para poder ejecutar comandos Docker desde el contenedor
RUN apk add --no-cache docker-cli

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración de paquetes
COPY package*.json ./

# Instalar dependencias
RUN npm install --omit=dev

# Copiar código fuente
COPY . .

# Crear directorio para logs
RUN mkdir -p logs

# Exponer puerto
EXPOSE 3001

# Comando para ejecutar la aplicación
CMD ["npm", "start"]