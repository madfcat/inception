FROM alpine:3.19

# Install packages
RUN apk update && apk add --no-cache \
	php81-fpm

# Install wordpress
RUN mdkir -p /var/www/html \
	&& cd /var/www/html \
	&& wget 

CMD ["php-fpm", "-F"]