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
# Final stage: PHP-FPM + Nginx
# --------------------------
FROM php:8.2-fpm-alpine

# Install packages
RUN apk add --no-cache nginx supervisor bash curl icu-dev libzip-dev zlib-dev oniguruma-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip intl opcache

WORKDIR /var/www/html

# Copy application
COPY app /var/www/html

# Copy vendor from builder
COPY --from=builder /app/vendor /var/www/html/vendor

# Ensure storage and bootstrap/cache exist
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy Nginx and Supervisor configs
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80

# Start Supervisor (runs both PHP-FPM and Nginx)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
