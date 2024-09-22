# inception

## Environment variables

Here is an example of environment variables needed for this project. Place `.env` into `./srcs`.

WP_DUMMY_XML is optional and used to seed some dummy posts.

```
DOMAIN_NAME=vshchuki.hive.fi

# Certificates (Directory for private.key, certificate.crt)
CERTS_=./srcs/certificates

# Database configuration
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=wppassword
MYSQL_HOST=mariadb
MYSQL_PORT=3306

# WordPress configuration
WP_TABLE_PREFIX=wp_

WP_SITE_NAME=Inception @ Hive Helsinki
WP_ADMIN_USERNAME=cobb
WP_ADMIN_EMAIL=admin@example.com
WP_ADMIN_PASSWORD=adminpassword

WP_SIMPLE_USERNAME=mal
WP_SIMPLE_EMAIL=user@example.com
WP_SIMPLE_ROLE=subscriber
WP_SIMPLE_PASSWORD=userpassword

WP_DUMMY_XML=https://raw.githubusercontent.com/WPTT/theme-test-data/master/theme-preview.xml

# Django
DJANGO_SECRET_KEY=django-insecure-v!be*lqx7+xpzrm+49wzb^urr!$$c^1vp74h))lci-riqvlzcw

# Kuma
KUMA_DB_NAME=kuma
KUMA_DB_NAME=kuma
KUMA_DB_USER=kumauser
KUMA_DB_PASSWORD=kumapassword
```

## Django

Access the static website from: https://django.vshchuki.hive.fi/

### Setting up django development environment

- Use pyenv to get the correct version
- Setup local environment with venv

## Adminer

Access adminer panel from: https://adminer.vshchuki.hive.fi/

To access wordpress db:

- Server: `mariadb`
- Username: `wpuser`
- Password: `wppassword`
- Database: `wordpress`

To access wordpress db:

- Server: `mariadb`
- Username: `kumauser`
- Password: `kumapassword`
- Database: `kuma`

## Kuma

Access kuma panel from: https://vshchuki.hive.fi:3001/

To login:

- Hostname: `mariadb`
- Port: `3306`
- Username: `kumauser`
- Password: `kumapassword`
- Database Name: `kuma`

To start monitoring:

- Creat a new monitor of a HTTPS server with URL: `https://nginx/`
- Also tick: `Ignore TLS/SSL errors for HTTPS websites`
- `docker stop wordpress` to see that service is not available
- `docker start wordpress` to bring it back




## Inception tests @ Hive


### Copying vogsphere cloned files to a VM machine via SSH

```
scp -P 2222 -r ./inception vshchuki@127.0.0.1:/home/vshchuki/Documents/inception-vog
```

### Test if containers run main executable for PID 1

The PID 1 executable should be a main process

```
docker exec -it mariadb ps aux
docker exec -it wordpress ps aux
docker exec -it nginx ps aux
docker exec -it redis ps aux
docker exec -it adminer ps aux
docker exec -it pure-ftpd ps aux
docker exec -it django ps aux
docker exec -it kuma ps aux
```

### Check root user password in mariadb

```
docker exec -it mariadb /bin/sh
mysql -u root -p
```

The root password should be: `rootpassword`

### Useful docker commands

You can prune the dangling docker data with.

Remove all unused containers, networks, images (both dangling and unused), and optionally, volumes.

```
docker image prune
```

For images:

```
docker image prune
```

For cache:

```
docker builder prune
```