#!/bin/sh

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting MariaDB..."

# Function to initialize the database
initialize_db() {
	envsubst </usr/local/bin/script.sql >/var/lib/mysql/init_script.sql
	touch /var/lib/mysql/.mariadb_initialized
	echo "MariaDB initialized."
	exec mariadbd --init-file=/var/lib/mysql/init_script.sql
}

# Check if the database needs initialization
if [ ! -f /var/lib/mysql/.mariadb_initialized ]; then
	initialize_db
else
	echo "Database already initialized."
	exec mariadbd
fi
