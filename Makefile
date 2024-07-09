# Creamos las variables
DOCKER_COMPOSE_YAML = srcs/docker-compose.yml
MARIADB_DATA_DIR = /home/frmurcia/data/mariadb
WORDPRESS_DATA_DIR = /home/frmurcia/data/wordpress
IMAGES = mariadb nginx wordpress
VOLUMES = srcs_mariadb_data srcs_wordpress_data

# Objetivos
.PHONY: all build up down clean re restart create_dirs

# all depende de up
all: create_dirs

# El objetivo up levanta y construye los contenedores definidos en el archivo docker-compose.yml
build:
# la @ silencia esa linea en la salida
# -f indica que lo siguiente será el archivo de configuración docker-compose.yml
# el up levanta los contenedores
# el --build construye las imagenes antes de levantarlas
	@echo "Building..."
	@sudo docker-compose -f $(DOCKER_COMPOSE_YAML) build

up: 
	@sudo ocker-compose -f $(DOCKER_COMPOSE_YAML) up -d

down:
# Aqui lo unico diferente es el -v, elimina los volúmenes asociados a los contenedores
	@sudo docker-compose -f $(DOCKER_COMPOSE_YAML) down -v

fclean:
	@docker image prune -af
clean: down
# Eliminamos imágenes
	@sudo docker rmi -f $(IMAGES)
# Eliminamos volúmenes
	@sudo docker volume rm -f $(VOLUMES)
# re ejecuta los objetivos clean y luego up
re: clean up

restart: clean
# Eliminamos los directorios de datos de mariadb y wordpress
	@rm -rf $(MARIADB_DATA_DIR) $(WORDPRESS_DATA_DIR)
# Recreamos los directorios de mariadb y wordpress pero vacíos
# -p asegura que no se generen errores si el directorio ya existe
	@mkdir -p $(MARIADB_DATA_DIR) $(WORDPRESS_DATA_DIR)

create_dirs:
	@mkdir -p $(MARIADB_DATA_DIR) $(WORDPRESS_DATA_DIR)
