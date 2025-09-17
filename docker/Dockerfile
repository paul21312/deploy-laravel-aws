# --------------------------
# Builder stage (for dependencies, optional)
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

# Install Nginx and bash
RUN apk add --no-cache nginx bash curl

WORKDIR /var/www/html

# Copy application
COPY app /var/www/html

# Ensure public directory exists
RUN mkdir -p /var/www/html/public

# Copy Nginx config
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Ensure /run/nginx exists
RUN mkdir -p /run/nginx

EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
