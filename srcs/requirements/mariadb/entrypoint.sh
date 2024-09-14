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

	# Change root password
	echo "Setting root password..."
	mysql --user=mysql <<-EOSQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
		FLUSH PRIVILEGES;
	EOSQL

	# Initialize wordpress db
	mysql --user=mysql <<-EOSQL
		CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'wordpress.inception_network' IDENTIFIED BY '${MYSQL_PASSWORD}';
		FLUSH PRIVILEGES;
	EOSQL

	echo "Database and user created successfully."

	# Shut down MariaDB
	mariadb-admin shutdown
	wait $MARIADB_PID
}

# Check if the database needs initialization
# if [ ! -d /var/lib/mysql/mysql ]; then
if [ ! -d /var/lib/mysql/wordpress ]; then
	initialize_db
fi

# Start MariaDB as PID 1
# exec mariadbd --user=mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_bin 
exec mariadbd --user=mysql
