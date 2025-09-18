FROM nginx:alpine

# Copy nginx configs
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/html

# Expose HTTP port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
