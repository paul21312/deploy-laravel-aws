# --------------------------
# Stage 1: Build PHP dependencies with Composer
# --------------------------
FROM composer:2 AS builder
WORKDIR /app

# Copy composer files from Laravel root
COPY app/composer.json app/composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --no-progress --optimize-autoloader

# --------------------------
# Stage 2: Final container with PHP-FPM + Nginx
# --------------------------
FROM php:8.2-fpm-alpine

# Install Nginx and necessary PHP extensions
RUN apk add --no-cache nginx bash curl icu-dev libzip-dev zlib-dev oniguruma-dev git unzip \
    && docker-php-ext-install pdo pdo_mysql mbstring zip intl opcache

WORKDIR /var/www/html

# Copy entire Laravel app source code
COPY app/ /var/www/html/

# Copy vendor from builder stage
COPY --from=builder /app/vendor /var/www/html/vendor

# Ensure storage and bootstrap/cache exist and are writable
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache /run/nginx \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# --------------------------
# Nginx configuration
# --------------------------
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf

# Expose HTTP port
EXPOSE 80

# Start PHP-FPM and Nginx together
CMD ["sh", "-c", "php-fpm -F & nginx -g 'daemon off;'"]
