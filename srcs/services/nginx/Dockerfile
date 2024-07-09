# Baja el SO de Debian, le dice a Docker con qué sistema operativo debe ejecutarse la máquina virtual
FROM debian:bullseye

# Actualizamos la lista de paquetes apt-get
RUN apt-get update

# instalamos nginx y openssl; openssl se encarga del certificado de seguridad
RUN apt-get install -y nginx openssl

# Creamos un directorio para almacenar las claves SSL
RUN mkdir -p /etc/nginx/ssl

# Genera el certificado ssl y sus claves
RUN openssl req -x509 -nodes \
-out /etc/nginx/ssl/frmurcia.42.fr.crt \
-keyout /etc/nginx/ssl/frmurcia.42.fr.key \
-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=frmurcia.42.fr/UID=frmurcia"

# Copiamos el archivo de configuracion en el contenedor
COPY conf/frmurcia.42.fr /etc/nginx/sites-available

# Creamos un enlace simbolico de la configuracion
RUN ln -s /etc/nginx/sites-available/frmurcia.42.fr /etc/nginx/sites-enabled

# Creamos una carteta y copiamos un html para comprobar que esta funcionando
RUN mkdir -p /var/www/frmurcia
COPY tools/index.html /var/www/frmurcia

EXPOSE 443

# Ejecutamos nginx para levantar el servidor
CMD ["nginx", "-g", "daemon off;"]
