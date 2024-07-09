# Especificamos la imagen base desde la que construimos el contenedor: Debian Buster.
FROM debian:bullseye

# RUN ejecuta comandos durante el proceso de construcción de la imagen
# Actualiza el sistema e instala los paquetes necesarios. -y es contestar yes
RUN apt update -y && \
	apt upgrade -y && \
	apt-get install -y mariadb-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# COPY copia archivos desde el sistema de archivos local al sistema de archivos del contenedor
# COPY /conf/mysqld.conf /etc/mysql/conf.d/
COPY /conf/mysqld.conf /etc/mysql/mariadb.conf.d/

# Copiamos el archivo de configuracion
COPY /tools/mariadb.sh /mariadb.sh

# Damos los permisos necesarios, verificar si es necesario
RUN chmod +x mariadb.sh

# EXPOSE informa a Docker que el contenedor escucha en el puerto especificado en tiempo de ejecución
# (es el puerto predeterminado para MariaDb y el que manda el subject)
EXPOSE 3306

# ENTRYPOINT define el script /mariadb.sh como el comando que se ejecutará siempre (en bash)
# cuando se inicie el contenedor
ENTRYPOINT ["bash", "/mariadb.sh"]

# Iniciamos el servicio MariaDB
# Lo configura para que escuche en todas las interfaces de red (0.0.0.0) 
CMD ["mysqld", "--bind-address=0.0.0.0"]
