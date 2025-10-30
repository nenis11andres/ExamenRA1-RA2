FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y apache2 php php-cli libapache2-mod-php php-mbstring php-xml php-pdo php-mysql unzip curl git procps && \
    apt-get clean

RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY gym/ ./

RUN composer install --no-interaction --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html || true
RUN chmod -R 755 /var/www/html || true

COPY docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf 

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"] 
