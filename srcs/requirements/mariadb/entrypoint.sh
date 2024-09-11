#!/bin/bash

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting to create mariadb..."

# Function to initialize the database
initialize_db() {
	echo "Initializing MariaDB database..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	# Start MariaDB in the background temporarily
	mysqld_safe --datadir=/var/lib/mysql &
	MARIADB_PID=$!

	# Wait for MariaDB to start
	until mysqladmin ping --silent; do
		sleep 1
	done

	echo "MariaDB started successfully."

	# Run initialization script
	mysql --user=root <<-EOSQL
		CREATE DATABASE IF NOT EXISTS wordpress;
		CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppassword';
		GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
		FLUSH PRIVILEGES;
	EOSQL

	echo "Database and user created successfully."

	# Shut down MariaDB
	mysqladmin shutdown
	wait $MARIADB_PID
}

# Check if the database needs initialization
if [ ! -d /var/lib/mysql/mysql ]; then
	initialize_db
fi

# Start MariaDB as PID 1
exec mysqld_safe
