FROM alpine
EXPOSE 80

ENV PHP_INI='/etc/php7/php.ini'
ENV DB_HOST=''
ENV DB_PORT=3306
ENV DB_USER=''
ENV DB_NAME=''
ENV DB_PASS=''

COPY . /app

RUN apk add --no-cache php-cli php-mysqli php-session php7-pecl-memcached \
    && cp /app/config/php.ini /etc/php7/php.ini

WORKDIR /app
ENTRYPOINT ["sh", "-c", "php -c $PHP_INI -S 0.0.0.0:80 -t /app"]
