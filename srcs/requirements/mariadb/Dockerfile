FROM alpine:3.19

# Install packages
RUN apk update && apk add --no-cache \
	mariadb \
	mariadb-client \ 
	envsubst

# Create the required directory for MariaDB runtime files
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Initialize the MariaDB data directory
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Copy custom config to expose port 3306
COPY ./conf/mymariadb-server.cnf /etc/my.cnf.d/

# Use the custom entrypoint script
WORKDIR /usr/local/bin/

COPY script.sql /usr/local/bin/

RUN mkdir -p /usr/local/bin
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER mysql

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
