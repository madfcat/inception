FROM alpine:3.19

# Install packages
RUN apk update && apk add --no-cache \
	mariadb \
	mariadb-client

# Create the required directory for MariaDB runtime files
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Initialize the MariaDB data directory
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Add the custom entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy custom config to expose port 3306
COPY ./conf/mymariadb-server.cnf /etc/my.cnf.d/

USER mysql

# Use the custom entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
