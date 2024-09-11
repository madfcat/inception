#!/bin/sh

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting mariadb..."

# Function to initialize the database
initialize_db() {
	echo "Initializing MariaDB database..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	# Start MariaDB in the background temporarily
	mariadbd --user=mysql --datadir=/var/lib/mysql &
	MARIADB_PID=$!

	# Wait for MariaDB to start
	until mariadb-admin ping --silent; do
		sleep 1
	done

	echo "MariaDB started successfully."

	# Run initialization script
	mysql --user=mysql <<-EOSQL
		CREATE DATABASE IF NOT EXISTS wordpress;
		CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppassword';
		GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
		FLUSH PRIVILEGES;
	EOSQL

	echo "Database and user created successfully."

	# Shut down MariaDB
	mariadb-admin shutdown
	wait $MARIADB_PID
}

# Check if the database needs initialization
if [ ! -d /var/lib/mysql/mysql ]; then
	initialize_db
fi

# Start MariaDB as PID 1
exec mariadbd --user=mysql
