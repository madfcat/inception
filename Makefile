# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vshchuki <vshchuki@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/04 16:27:29 by vshchuki          #+#    #+#              #
#    Updated: 2024/09/13 23:30:41 by vshchuki         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# TODO:
# Create /home/login/data/wp_data
# Create /home/login/data/db_data

# Export env variables
# export $(shell sed 's/=.*//' "./srcs/.env")
DOMAIN_NAME=vshchuki.hive.fi
FILE=/etc/hosts
ENTRY=127.0.0.1   $(DOMAIN_NAME)

all:
	@if ! grep -q $(DOMAIN_NAME) $(FILE); then \
		echo "Domain not found. Adding entry..."; \
		echo "$(ENTRY)" >> "$(FILE)"; \
		echo "Entry added: $(ENTRY)"; \
	else \
		echo "Domain already exists in $(FILE)."; \
	fi

	docker compose --env-file ./srcs/.env build --no-cache
	docker compose --env-file ./srcs/.env up

clean:
	docker compose down -v
	docker system prune -f


fclean: clean
	rm -rf ./volumes/db_data/*
	rm -rf ./volumes/wp_data/*
	docker network rm inception_network
	docker image rm -f wordpress mariadb nginx

re: fclean all

.PHONY: all clean fclean re