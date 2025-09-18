# Stage 1: Build Laravel PHP dependencies
FROM composer:2 AS builder
WORKDIR /app
COPY app/composer.json app/composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --no-progress --optimize-autoloader

# Stage 2: Final Nginx container
FROM nginx:alpine

# Copy app code
COPY app /var/www/html

# Copy vendor from builder
COPY --from=builder /app/vendor /var/www/html/vendor

# Copy Nginx configs
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Nginx runs by default in foreground in this image
