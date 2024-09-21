#!/bin/sh

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting nginx..."

# # Generate self-signed certificate

if [ ! -f "/etc/ssl/certs/certificate.crt" ] || [ ! -f "/etc/ssl/private/private.key" ]; then
	echo "certificate.crt or private.key were not copied from ${CERTS_}."
	echo "A self-signed certificate will be created..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/private.key \
	-out /etc/ssl/certs/certificate.crt \
	-subj "/C=US/ST=California/L=San Francisco/O=My Company/OU=IT Department/CN=*.${DOMAIN_NAME}"
fi

exec nginx -g "daemon off;"