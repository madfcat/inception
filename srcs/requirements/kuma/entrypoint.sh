#!/bin/sh

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting kuma..."

# Function to wait for MariaDB to be ready
wait_for_mariadb() {
	echo "Waiting for MariaDB to be available at ${MYSQL_HOST}:${MYSQL_PORT}..."
	until mariadb-admin ping -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" --silent; do
		echo "MariaDB is not available yet. Waiting..."
		sleep 2
	done
	echo "MariaDB is available."
}

# Wait for MariaDB to be ready
wait_for_mariadb

mysql -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
	CREATE DATABASE IF NOT EXISTS ${KUMA_DB_NAME};
	CREATE USER IF NOT EXISTS '${KUMA_DB_USER}'@'%' IDENTIFIED BY '${KUMA_DB_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${KUMA_DB_NAME}.* TO '${KUMA_DB_USER}'@'%';
	FLUSH PRIVILEGES;
EOSQL
echo "Database for kuma created successfully."

exec /usr/bin/dumb-init -- npm run start-server
