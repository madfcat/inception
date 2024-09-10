#!/bin/bash

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting to create mariadb..."

# Forward signals to the main process
exec "$@"

# Initialize the MariaDB data directory if it doesn't already exist
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Initializing MariaDB database..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background
mysqld_safe &

# Wait for MariaDB to start
until mysqladmin ping --silent; do
    sleep 1
done

# Run initialization script
mysql --user=root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS wordpress;
    CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppassword';
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
    FLUSH PRIVILEGES;
EOSQL

# Keep MariaDB running
wait