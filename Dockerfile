FROM alpine:3.7

# Install packages
RUN apk upgrade -U && apk --no-cache add php7 php7-fpm php-zip php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-simplexml php7-ctype \
    php7-mbstring php7-gd php7-tokenizer php7-xmlwriter php7-session supervisor curl git \
    php7-pdo php7-pdo_pgsql php7-iconv php7-redis php7-pecl-amqp php7-fileinfo nginx

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Copy run script
COPY docker/run.sh /run.sh

# Configure nginx
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY docker/php/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY docker/php/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Fix open() nginx.pid
RUN mkdir -p /run/nginx/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
