# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vshchuki <vshchuki@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/04 16:27:29 by vshchuki          #+#    #+#              #
#    Updated: 2024/09/14 16:00:09 by vshchuki         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# TODO:
# Create /home/login/data/wp_data
# Create /home/login/data/db_data

# Export env variables
# export $(shell sed 's/=.*//' "./srcs/.env")

LOGIN=vshchuki
DOMAIN_NAME=$(LOGIN).hive.fi
FILE=/etc/hosts
ENTRY=127.0.0.1   $(DOMAIN_NAME)

# sudo chown -R 1000:1000 $(WP_VOLUME_PATH)
# sudo chmod -R 755 $(WP_VOLUME_PATH)
# sudo chown -R 1000:1000 $(MYSQL_VOLUME_PATH)
# sudo chmod -R 755 $(MYSQL_VOLUME_PATH)

# WP_VOLUME_PATH=/Users/vshchuki/data/wp_data
# MYSQL_VOLUME_PATH=/Users/vshchuki/data/db_data
# WP_VOLUME_PATH=/tmp/data/wp_data
# MYSQL_VOLUME_PATH=/tmp/data/db_data

USER_DIR=/Users/$(LOGIN)

WP_VOLUME_PATH=$(USER_DIR)/data/wp_data
MYSQL_VOLUME_PATH=$(USER_DIR)/data/db_data


all:
	sudo mkdir -p $(WP_VOLUME_PATH)
	sudo mkdir -p $(MYSQL_VOLUME_PATH)
	sudo chown -R mcp:admin $(USER_DIR)
	sudo chmod -R 755 $(USER_DIR)

	@if ! grep -q $(DOMAIN_NAME) $(FILE); then \
		echo "Domain not found. Adding entry..."; \
		echo "$(ENTRY)" | sudo tee -a $(FILE) > /dev/null; \
		echo "Entry added: $(ENTRY)"; \
	else \
		echo "Domain already exists in $(FILE)."; \
	fi

	docker compose --env-file ./srcs/.env build --no-cache
	docker compose --env-file ./srcs/.env up

stop:
	docker compose down

fclean: stop
	sudo rm -rf $(WP_VOLUME_PATH)/*
	sudo rm -rf $(MYSQL_VOLUME_PATH)/*
	docker image rm wordpress mariadb nginx 2>/dev/null || true
	docker volume rm wp_data db_data 2>/dev/null || true
	docker volume rm inception_wp_data1 inception_db_data1 2>/dev/null || true
	docker network rm inception_network 2>/dev/null || true

re: fclean all

.PHONY: all clean fclean re