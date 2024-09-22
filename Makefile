# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vshchuki <vshchuki@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/04 16:27:29 by vshchuki          #+#    #+#              #
#    Updated: 2024/09/22 22:04:22 by vshchuki         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SHELL := /bin/bash

LOGIN=vshchuki
DOMAIN_NAME=$(LOGIN).hive.fi
ADMINER_DOMAIN_NAME=adminer.$(DOMAIN_NAME)
DJANGO_DOMAIN_NAME=django.$(DOMAIN_NAME)
KUMA_DOMAIN_NAME=kuma.$(DOMAIN_NAME)
HOSTS_FILE=/etc/hosts
ENTRY=127.0.0.1   $(DOMAIN_NAME)
ADMINER_ENTRY=127.0.0.1   $(ADMINER_DOMAIN_NAME)
DJANGO_ENTRY=127.0.0.1   $(DJANGO_DOMAIN_NAME)
KUMA_ENTRY=127.0.0.1   $(KUMA_DOMAIN_NAME)


# For Linux:
# HOME_DIR=/home
# For MacOS:
HOME_DIR=/Users

USER_DIR=$(HOME_DIR)/$(LOGIN)

# Volumes directories
WP_VOLUME_PATH=$(USER_DIR)/data/wp_data
MYSQL_VOLUME_PATH=$(USER_DIR)/data/db_data

# Get current username and groupname
USER_NAME := $(shell whoami)
GROUP_NAME := $(shell id -gn)

all:
	sudo mkdir -p $(WP_VOLUME_PATH)
	sudo mkdir -p $(MYSQL_VOLUME_PATH)
	@if [ ! -f .init ]; then \
		echo "Running all for the first time..."; \
		sudo chown -R $(USER_NAME):$(GROUP_NAME) $(USER_DIR); \
		sudo chmod -R 777 $(USER_DIR)/data/; \
		touch .init; \
	fi

	@if ! grep -q "^127\.0\.0\.1[[:space:]]\+$(DOMAIN_NAME)" $(HOSTS_FILE); then \
		echo "Domain not found. Adding entry..."; \
		echo "$(ENTRY)" | sudo tee -a $(HOSTS_FILE) > /dev/null; \
		echo "Entry added: $(ENTRY)"; \
	else \
		echo "Domain already exists in $(HOSTS_FILE)."; \
	fi
	@if ! grep -q "^127\.0\.0\.1[[:space:]]\+$(ADMINER_DOMAIN_NAME)" $(HOSTS_FILE); then \
		echo "Subdomain not found. Adding entry..."; \
		echo "$(ADMINER_ENTRY)" | sudo tee -a $(HOSTS_FILE) > /dev/null; \
		echo "Entry added: $(ADMINER_ENTRY)"; \
	else \
		echo "Subomain already exists in $(HOSTS_FILE)."; \
	fi
	@if ! grep -q "^127\.0\.0\.1[[:space:]]\+$(DJANGO_DOMAIN_NAME)" $(HOSTS_FILE); then \
		echo "Subdomain not found. Adding entry..."; \
		echo "$(DJANGO_ENTRY)" | sudo tee -a $(HOSTS_FILE) > /dev/null; \
		echo "Entry added: $(DJANGO_ENTRY)"; \
	else \
		echo "Subomain already exists in $(HOSTS_FILE)."; \
	fi
	@if ! grep -q "^127\.0\.0\.1[[:space:]]\+$(KUMA_DOMAIN_NAME)" $(HOSTS_FILE); then \
		echo "Subdomain not found. Adding entry..."; \
		echo "$(KUMA_ENTRY)" | sudo tee -a $(HOSTS_FILE) > /dev/null; \
		echo "Entry added: $(KUMA_ENTRY)"; \
	else \
		echo "Subomain already exists in $(HOSTS_FILE)."; \
	fi

	docker compose -f ./srcs/docker-compose.yml build
	docker compose -f ./srcs/docker-compose.yml up

stop:
	docker compose -f ./srcs/docker-compose.yml down 

fclean:
	rm -f .init
	docker compose -f ./srcs/docker-compose.yml down --remove-orphans || true
	sudo rm -rf $(WP_VOLUME_PATH)
	sudo rm -rf $(MYSQL_VOLUME_PATH)
	docker image rm \
		wordpress \
		mariadb \
		nginx \
		redis \
		pure-ftpd \
		adminer \
		django \
		kuma \
		2>/dev/null || true
	docker volume rm wp_data db_data 2>/dev/null || true
	docker network rm inception_network 2>/dev/null || true
	@if grep -q "^127\.0\.0\.1[[:space:]]\+$(DOMAIN_NAME)" $(HOSTS_FILE); then \
		echo "Removing entry for $(DOMAIN_NAME) from $(HOSTS_FILE)..."; \
		if [[ "$$OSTYPE" == "darwin"* ]]; then \
			sudo sed -i '' "/^127\.0\.0\.1[[:space:]]\{1,\}$(DOMAIN_NAME)/d" $(HOSTS_FILE); \
		else \
			sudo sed -i "/^127\.0\.0\.1[[:space:]]\+$(DOMAIN_NAME)/d" $(HOSTS_FILE); \
		fi; \
	fi
	@if grep -q "^127\.0\.0\.1[[:space:]]\+$(ADMINER_DOMAIN_NAME)" $(HOSTS_FILE); then \
		echo "Removing entry for $(ADMINER_DOMAIN_NAME) from $(HOSTS_FILE)..."; \
		if [[ "$$OSTYPE" == "darwin"* ]]; then \
			sudo sed -i '' "/^127\.0\.0\.1[[:space:]]\{1,\}$(ADMINER_DOMAIN_NAME)/d" $(HOSTS_FILE); \
		else \
			sudo sed -i "/^127\.0\.0\.1[[:space:]]\+$(ADMINER_DOMAIN_NAME)/d" $(HOSTS_FILE); \
		fi; \
	fi
	@if grep -q "^127\.0\.0\.1[[:space:]]\+$(DJANGO_DOMAIN_NAME)" $(HOSTS_FILE); then \
		echo "Removing entry for $(DJANGO_DOMAIN_NAME) from $(HOSTS_FILE)..."; \
		if [[ "$$OSTYPE" == "darwin"* ]]; then \
			sudo sed -i '' "/^127\.0\.0\.1[[:space:]]\{1,\}(DJANGO_DOMAIN_NAME)/d" $(HOSTS_FILE); \
		else \
			sudo sed -i "/^127\.0\.0\.1[[:space:]]\+$(DJANGO_DOMAIN_NAME)/d" $(HOSTS_FILE); \
		fi; \
	fi
	@if grep -q "^127\.0\.0\.1[[:space:]]\+$(KUMA_DOMAIN_NAME)" $(HOSTS_FILE); then \
		echo "Removing entry for $(KUMA_DOMAIN_NAME) from $(HOSTS_FILE)..."; \
		if [[ "$$OSTYPE" == "darwin"* ]]; then \
			sudo sed -i '' "/^127\.0\.0\.1[[:space:]]\{1,\}(KUMA_DOMAIN_NAME)/d" $(HOSTS_FILE); \
		else \
			sudo sed -i "/^127\.0\.0\.1[[:space:]]\+$(KUMA_DOMAIN_NAME)/d" $(HOSTS_FILE); \
		fi; \
	fi

re: fclean all

.PHONY: all clean fclean re