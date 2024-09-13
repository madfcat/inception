FROM alpine:3.19

RUN apk update && apk add --no-cache \
	nginx \
	openssl

# Copy custom Nginx configuration
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /usr/local/bin
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]