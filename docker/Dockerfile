# --------------------------
# Stage 1: Build PHP dependencies
# --------------------------
FROM composer:2 AS builder
WORKDIR /app

# Copy only composer files to cache dependencies
COPY app/composer.json app/composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --no-progress --optimize-autoloader

# --------------------------
# Stage 2: Final container with PHP-FPM + Nginx
# --------------------------
FROM nginx:alpine

# Install PHP-FPM and required extensions
RUN apk add --no-cache \
        php8 php8-fpm php8-mbstring php8-pdo php8-pdo_mysql php8-opcache \
        php8-zip php8-intl php8-json php8-iconv bash curl icu-dev libzip-dev oniguruma-dev \
    && mkdir -p /run/nginx /var/www/html

# Set working directory
WORKDIR /var/www/html

# Copy Laravel app code
COPY app /var/www/html

# Copy custom Nginx configs
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Ensure Laravel storage & cache directories exist and are writable
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R nginx:nginx /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose HTTP port
EXPOSE 80

# Start PHP-FPM and Nginx together
CMD ["sh", "-c", "php-fpm8 -F & nginx -g 'daemon off;'"]