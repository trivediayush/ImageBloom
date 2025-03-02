# Build stage
FROM node:16 AS build

WORKDIR /app

# Copy package dependencies first for better caching
COPY package*.json ./
RUN npm install

# Copy the application code
COPY . .

# Create a simple .env file for the build process
# This avoids interpolation issues during build time
RUN echo "VITE_API_KEY=dummy_key_for_build" > .env

# Modify vite.config.js to handle environmental variables better
RUN if [ -f vite.config.js ]; then \

      sed -i 's/import.meta.env.VITE_API_KEY/process.env.VITE_API_KEY/g' src/App.jsx || true; \
    fi

# Build the application
RUN VITE_API_KEY=$VITE_API_KEY npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html

# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
