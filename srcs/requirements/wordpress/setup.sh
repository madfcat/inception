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
	wp config create --dbname="${WP_DB_NAME}" \
		--dbuser="${WP_DB_USER}" \
		--dbpass="${WP_DB_PASSWORD}" \
		--dbhost="${WP_DB_HOST}" \
		--dbprefix="${WP_TABLE_PREFIX}" \
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
	wp core install --url="https://${HTTP_HOST}" \
		--title="${WP_SITE_NAME}" \
		--admin_user="${WP_ADMIN_USERNAME}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--path=/var/www/html \
		--allow-root

	# Update site URL and home URL (if needed)
	# echo "HOST is ${HTTP_HOST}"
	# wp option update siteurl "https://${HTTP_HOST}" --path=/var/www/html --allow-root
	# wp option update home "https://${HTTP_HOST}" --path=/var/www/html --allow-root

	# Create a simple user
	wp user create $WP_SIMPLE_USERNAME $WP_SIMPLE_EMAIL \
		--role="${WP_SIMPLE_ROLE}" \
		--user_pass="${WP_SIMPLE_PASSWORD}"

	# Install and activate a theme (replace 'twentytwentyone' with your theme)
	# wp theme install twentytwentyone --activate --path=/var/www/html --allow-root
	wp theme install kadence --activate --path=/var/www/html --allow-root

	# Import dummy content
	if wget --spider "$WP_DUMMY_XML" 2>/dev/null; then
		wp plugin install wordpress-importer --activate
		echo "Dummy content file exists at $WP_DUMMY_XML. Downloading..."
		wget "$WP_DUMMY_XML" -O ./theme-preview.xml
		wp post delete $(wp post list --post_type=post --format=ids) --force
		wp import ./theme-preview.xml --authors=create
		wp post update $(wp post list --post_type=post --format=ids) --post_author=1
	else
		echo "Dummy content file does not exist at $URL"
	fi

	echo "WordPress installation complete!"
else
	echo "WordPress is already installed."
fi

# Start PHP-FPM in the foreground to keep the container running
exec php-fpm81 -F -R
