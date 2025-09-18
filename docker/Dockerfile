# --------------------------
# Builder stage (PHP dependencies)
# --------------------------
FROM composer:2 AS builder
WORKDIR /app
COPY app/composer.json app/composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --no-progress --optimize-autoloader

# --------------------------
# Final stage: PHP-FPM + Nginx
# --------------------------
FROM php:8.2-fpm-alpine

RUN apk add --no-cache nginx bash curl icu-dev libzip-dev zlib-dev oniguruma-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip intl opcache

WORKDIR /var/www/html

# Copy app code
COPY app /var/www/html

# Copy vendor from builder
COPY --from=builder /app/vendor /var/www/html/vendor

# Ensure storage/cache folders exist
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache /run/nginx \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy Nginx configs
COPY /docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY /docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start PHP-FPM and Nginx
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
