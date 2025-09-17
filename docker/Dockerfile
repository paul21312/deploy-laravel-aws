# --------------------------
# Builder stage: install PHP dependencies
# --------------------------
FROM composer:2 AS builder
WORKDIR /app

# Copy only composer files
COPY app/composer.json app/composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --no-interaction --prefer-dist --no-progress --optimize-autoloader

# --------------------------
# Final stage: Nginx only
# --------------------------
FROM alpine:latest

# Install Nginx, bash, curl
RUN apk add --no-cache nginx bash curl

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY app /var/www/html

# Ensure public directory exists
RUN mkdir -p /var/www/html/public

# Copy Nginx config files
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Ensure /run/nginx exists
RUN mkdir -p /run/nginx

# Expose HTTP port
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
