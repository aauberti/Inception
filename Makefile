DATA_PATH = /home/aaub/data
COMPOSE_FILE = ./srcs/docker-compose.yaml

all: up

up:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	docker-compose -f $(COMPOSE_FILE) up -d --build

down:
	docker-compose -f $(COMPOSE_FILE) down

clean: down
	docker system prune -f

fclean: clean
	@sudo rm -rf $(DATA_PATH)/mariadb
	@sudo rm -rf $(DATA_PATH)/wordpress
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker image rm $$(docker image ls -a -q) 2>/dev/null || true

re: fclean all

.PHONY: all up down clean fclean re