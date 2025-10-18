# === BUILD STAGE ===
FROM node:20-alpine AS build

WORKDIR /app

# Install deps
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build static files
RUN npm run build

# === SERVE STAGE ===
FROM nginx:alpine

# Copy built files
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 (standard for web servers)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
