#!/bin/sh

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting MariaDB..."

# Function to initialize the database
initialize_db() {
	envsubst </usr/local/bin/script.sql >/var/lib/mysql/init_script.sql
	exec mariadbd --init-file=/var/lib/mysql/init_script.sql
}

# Check if the database needs initialization
if [ ! -d /var/lib/mysql/.mariadb_initialized ]; then
	initialize_db
	# Create a flag file after successful initialization
	touch /var/lib/mysql/.mariadb_initialized
else
	exec mariadbd
fi
