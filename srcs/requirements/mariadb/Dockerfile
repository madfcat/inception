FROM alpine:3.19

# Install packages
RUN apk update && apk add --no-cache \
	mariadb \
	mariadb-client

# Initialize the MariaDB data directory
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

CMD ["mysqld"]