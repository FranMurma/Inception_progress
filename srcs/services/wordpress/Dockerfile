# Baja Debian, le dice a Docker con que sistema operativo debe ejecutarse la maquina virtual
FROM debian:bullseye

# RUN ejecuta comandos de terminal para actualizar el sistema e instalar los paquetes necesarios
RUN apt-get update && apt-get -y install php7.3 php-mysql php-fpm mariadb-server wget

# Exponemos el puerto 9000 que es donde estara wordpress
EXPOSE 9000

# Copy el fichero www.conf en php/7.3/fpm/pool.d
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

# Copiamos el script
COPY ./tools/my_wordpress.sh /var/www/

# Otorgamos permisos para ejecutar el script
RUN chmod +x /var/www/my_wordpress.sh

# Ejecutamos el script my_wordpress.sh cuando se inicia el contenedor
ENTRYPOINT [ "/var/www/my_wordpress.sh" ]

# Iniciamos PHP-FPM en modo foreground (nodaemonize) para mantener el contenedor en ejecución
CMD ["/usr/sbin/php-fpm7.3", "--nodaemonize"]
