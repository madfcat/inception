FROM alpine:3.19

RUN apk update && apk add --no-cache \
php81 \
php81-fpm \
php81-mysqli \
php81-session \
php81-json \
php81-mbstring \
curl

# Update CA certificates
RUN apk update && apk add --no-cache ca-certificates

# # Create the Adminer directory and download Adminer
RUN mkdir -p /var/www/html
RUN curl -k -L -o /var/www/html/index.php https://www.adminer.org/latest.php

# Set the working directory
WORKDIR /var/www/html

# Copy override config for PHP-FPM
COPY ./conf/wxyz.conf /etc/php81/php-fpm.d/

CMD ["php-fpm81", "-F"]