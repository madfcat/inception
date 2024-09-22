FROM alpine:3.19

WORKDIR /var/www/html

# Install packages
RUN apk update && apk add --no-cache \
	php81 \
	php81-phar \
	php81-curl \
	php81-fpm \
	php81-mysqli \
	php81-mbstring \
	php81-json \
	php81-session \
	php81-gd \
	php81-iconv \
	php81-xml \
	php81-simplexml \
	php81-zip \
	php81-tokenizer \
	php81-dom \
	mariadb-client

# Create a symlink for `php`
RUN ln -s /usr/bin/php81 /usr/bin/php

# Install wp-cli
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

# Entry point script to automate WordPress setup
RUN mkdir -p /usr/local/bin
COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Copy override config for PHP-FPM
COPY ./conf/wxyz.conf /etc/php81/php-fpm.d/

ENTRYPOINT ["/usr/local/bin/setup.sh"]