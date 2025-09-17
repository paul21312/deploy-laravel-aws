# builder
FROM composer:2 as builder
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --no-progress --optimize-autoloader

# final
FROM php:8.2-fpm-alpine
RUN apk add --no-cache nginx supervisor bash curl icu-dev libzip-dev zlib-dev oniguruma-dev \
 && docker-php-ext-install pdo pdo_mysql mbstring zip intl opcache

WORKDIR /var/www/html
COPY . /var/www/html
COPY --from=builder /app/vendor /var/www/html/vendor

COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf

RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
