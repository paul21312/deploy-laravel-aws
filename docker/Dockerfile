# --------------------------
# Builder stage: install PHP dependencies
# --------------------------
FROM composer:2 AS builder
WORKDIR /app

# Copy only composer files for dependency install
COPY app/composer.json app/composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --no-interaction --prefer-dist --no-progress --optimize-autoloader

# --------------------------
# Final stage: Nginx + PHP-FPM
# --------------------------
FROM php:8.2-fpm-alpine

# Install Nginx and required packages
RUN apk add --no-cache nginx bash curl icu-dev libzip-dev zlib-dev oniguruma-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip intl opcache

WORKDIR /var/www/html

# Copy application code
COPY app /var/www/html

# Copy vendor from builder stage
COPY --from=builder /app/vendor /var/www/html/vendor

# Ensure storage and bootstrap/cache exist
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy Nginx configs
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Ensure /run/nginx exists
RUN mkdir -p /run/nginx

EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
