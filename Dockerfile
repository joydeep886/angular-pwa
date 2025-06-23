# Build stage
FROM node:22-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the Angular app
RUN npm run build

# Production stage
FROM node:22-alpine

WORKDIR /app

# Install serve package globally
RUN npm install -g serve

# Copy built app from build stage
COPY --from=build /app/dist/pwa-app/browser ./dist

# Expose port
EXPOSE 3000

# Serve the app
CMD ["serve", "-s", "dist", "-l", "3000"]