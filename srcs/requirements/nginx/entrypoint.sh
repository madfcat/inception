#!/bin/sh

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting nginx..."

exec nginx -g "daemon off;"