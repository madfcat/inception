# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vshchuki <vshchuki@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/04 16:27:29 by vshchuki          #+#    #+#              #
#    Updated: 2024/09/10 23:10:58 by vshchuki         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all:
	docker compose --env-file ./srcs/.env build --no-cache
	docker compose --env-file ./srcs/.env up

clean:
	docker compose down -v
	docker system prune -f


fclean: clean
	docker network rm inception_network
	docker image rm -f wordpress mariadb

re: fclean all

.PHONY: all clean fclean re