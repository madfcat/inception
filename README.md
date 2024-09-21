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

# WordPress configuration
WP_DB_HOST=mariadb:3306
WP_TABLE_PREFIX=wp_

WP_SITE_NAME=Inception @ Hive Helsinki

# Admin user
WP_ADMIN_USERNAME=cobb
WP_ADMIN_EMAIL=admin@example.com
WP_ADMIN_PASSWORD=adminpassword

# Second user
WP_SIMPLE_USERNAME=mal
WP_SIMPLE_EMAIL=user@example.com
WP_SIMPLE_ROLE=subscriber
WP_SIMPLE_PASSWORD=userpassword

WP_DUMMY_XML=https://raw.githubusercontent.com/WPTT/theme-test-data/master/theme-preview.xml

# Django
DJANGO_SECRET_KEY=django-insecure-v!be*lqx7+xpzrm+49wzb^urr!$$c^1vp74h))lci-riqvlzcw
```

## Copying vogsphere cloned files to a VM machine via SSH

```
scp -P 2222 -r ./inception vshchuki@127.0.0.1:/home/vshchuki/Documents/inception-vog
```

## Setting up django development environment


- Use pyenv to get the correct version
- Setup local environment with venv

## Kuma

To monitor HTTPS of the server add https://nginx/

```

```