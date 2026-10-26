FROM php:8.1-apache
COPY . /var/www/html/
EXPOSE 80
RUN chown -R www-data:www-data /var/www/html