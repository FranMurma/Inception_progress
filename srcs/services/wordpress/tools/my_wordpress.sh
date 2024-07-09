#!/bin/bash

# Indicamos que vamos a escuchar en el puerto 9000 para wordpress
# sed edita el flujo, -i: in-place, lo hace en el lugar (sin -i lo haría por pantalla)
# s: sustituir lo que hay entre dos / (/../) por lo que hay entre el segundo grupo de (/.../). 
# \/ es para escapar la / que no es de sed sino de carpeta. Cambia "listen = /run/php/php7.3-fpm.sock" por "listen = 9000"
# en el archivo /etc/php/7.3/fpm/pool.d/www.conf
sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/" "/etc/php/7.3/fpm/pool.d/www.conf"

# chown: change owner; -R: recursivamente; antes de los ":" usuario propietario; después, grupo propietario. 
chown -R www-data:www-data /var/www/*

# Cambiamos los permisos de todo lo que haya en /var/www/ a 755 (rwxr-xr-x)
chmod -R 755 /var/www/*
# -p crea los directorios intermedios si no existen
mkdir -p /run/php/
# creamos este archivo
touch /run/php/php7.3-fpm.pid

# Comprobamos si existe el archivo de configuracion, si no existe hemos de instalar y configurar wordpress
if [ ! -f /var/www/html/wp-config.php ]; then
	mkdir -p /var/www/html
	# Descargamos wp-cli.phar, herramienta de línea de comandos de WP que facilita la instalación
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	# Cambiamos el permiso de ejecución para hacerlo ejecutable
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
	cd /var/www/html
	# Descargamos con comandos cli (wp) wordpress y permitimos que el comando se ejecute como el usuario root
	wp core download --allow-root
	# Creamos la configuracion de wordpress (wp-config.php) indicandole la base de datos, etc.
	wp config create --allow-root --dbname=${DB_DATABASE} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=mariadb:3306
	# Con wp cli completamos la instalación configurando la base de datos, creando las tablas y el usuario administrador
	wp core install --allow-root --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USR} --admin_password=${WP_ADMIN_PWD} --admin_email=${WP_ADMIN_EMAIL}
	# Creamos otro usuario
	wp user create --allow-root ${WP_USR} ${WP_EMAIL} --user_pass=${WP_PWD}
fi

# Vamos a por comandos adicionales...
exec "$@"
