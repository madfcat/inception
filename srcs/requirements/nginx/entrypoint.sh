#!/bin/sh

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting nginx..."

# # Generate self-signed certificate

if [ -n "/etc/ssl/certs/certificate.crt" ] || [ -n "/etc/ssl/private/private.key" ]; then
	echo "certificate.crt or private.key were not copied from ${CERTS_}."
	echo "A self-signed certificate will be created..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/private.key \
	-out /etc/ssl/certs/certificate.crt \
	-subj "/C=US/ST=California/L=San Francisco/O=My Company/OU=IT Department/CN=example.com"
fi

exec nginx -g "daemon off;"