FROM alpine:3.19

RUN apk update && apk add --no-cache \
	nginx \
	openssl

# Copy custom Nginx configuration
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Copy certificates
RUN mkdir -p /etc/ssl/private /etc/ssl/certs
COPY ../../${CERTS_}/private.key* /etc/ssl/private/private.key;
COPY ../../${CERTS_}/certificate.crt* /etc/ssl/certs/certificate.crt;

RUN mkdir -p /usr/local/bin
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]