#!/bin/sh

# Exit immediately if any command returns a non-zero exit
set -e

echo "Starting wordpress..."

# If wp-config.php doesn't exist, create it
if [ ! -f /var/www/html/wp-config.php ]; then
	# Download WordPress if not already present
	wp core download --path=/var/www/html

	# Create wp-config.php file with the required database info
	echo "Creating wp-config.php file..."
	wp config create --dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}" \
		--dbhost="${WORDPRESS_DB_HOST}" \
		--path=/var/www/html \
		--allow-root

	# Additional configurations (e.g., WP_DEBUG)
	wp config set WP_DEBUG true --path=/var/www/html --allow-root

	echo "wp-config.php file created!"
fi

# If WordPress is not already installed, install it
if ! wp core is-installed --path=/var/www/html --allow-root; then
	echo "Installing WordPress..."

	# Install WordPress
	wp core install --url="http://localhost" \
		--title="My WordPress Site" \
		--admin_user="admin" \
		--admin_password="password" \
		--admin_email="admin@example.com" \
		--path=/var/www/html \
		--allow-root

	# Install and activate a theme (replace 'twentytwentyone' with your theme)
	wp theme install twentytwentyone --activate --path=/var/www/html --allow-root

	echo "WordPress installation complete!"
else
	echo "WordPress is already installed."
fi

# Start PHP-FPM in the foreground to keep the container running
exec php-fpm81 -F
