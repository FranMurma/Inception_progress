# Detener la ejecución en caso de error
set -e

# Iniciamos el servicio de MySQL/MariaDB:
echo "Starting MariaDB service..."
service mysql start;
# Si la salida ($?) no es igual a 0, entonces echo "Failed" y exit(1). Fin del if.
if [ $? -ne 0 ]; then
    echo "Failed to start MariaDB service"
    exit 1
fi

# Crea una base de datos con la variable de entorno DB_DATABASE, solo si esta no existe ya.
# mysql: comando base utilizado para interactuar con el servidor de bases de datos MariaDB desde la línea de comandos
# -e: execute. "CREATE DATABASE" crea una base de datos. "IF NO EXISTS", obvio. Y luego la variable de entorno definida
echo "Creating database if it doesn't exist..."
mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_DATABASE};"|| exit 2

# Creamos un usuario, DB_USER. Las \ es para que se lean bien las `. @ separa user de host y % es cualquier host.
# IDENTIFIED BY: Esta cláusula se usa para establecer o cambiar la contraseña del usuario especificado
# '${DB_PASSWORD}': este será su nuevo password
echo "Creating user if they don't exist..."
mysql -e "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"|| exit 3

# Anadimos un usuario root en 127.0.0.1 para permitir la conexion remota
# GRANT ALL PRIVILEGES ON: comando que otorga todos los permisos sobre todas las tablas a ese usuario
# Los permisos se otorgan a (TO) ${DB_USER}
echo "Granting privileges..."
mysql -e "GRANT ALL PRIVILEGES ON \`${DB_DATABASE}\`.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"|| exit 4

# ALTER USER: comando que modifica las propiedades de una cuenta de usuario en MariaDB
echo "Setting root user password..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"|| exit 5

# Recargamos database de privilegios (FLUSH PRIVILEGES hace que las tablas sql se actualicen automaticamente cuando las modifique)
echo "Flushing privileges..."
mysql -e "FLUSH PRIVILEGES;"|| exit 6

# Cerramos root. 
# mysqladmin: utilidad de línea de comandos de MariaDB para tareas administrativas sobre el servidor de bases de datos
# -u: indica el nombre del usuario con el que se ejecuta el comando (root). 
# -p: necesitará la contrasena y con -p y seguidamente la variable de entorno con la contrasena, la envía
# shutdown: indica a mysqladmin que cierre el servidor de bases de datos de manera ordenada y segura
echo "Shutting down MariaDB safely..."
mysqladmin -u root -p$DB_ROOT_PASSWORD shutdown || exit 7

echo "MariaDB configuration completed successfully."
# STOP mysql
service mysql stop

# exec "$@" permite que el script pase cualquier comando adicional especificado al iniciar el contenedor.
exec "$@"

# docker ps  para saber contenedores
# docker exec -t contenedor /bin/bash  para entrar en la teminal y poder probar sql

#       mysql -u root -p
# Para que me ensene una database:
#       show databases;
# Para que me ensene el user y el host
#       select user, host from mysql.user; 
# Si quieres crear una tabla:
#       use database_inception;
#       CREATE TABLE table_name(       id int NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Primary Key',     create_time DATETIME COMMENT 'Create Time',     name VARCHAR(255) );
#       show tables from database_inception

#docker exec -it mariadb sh
#mysql -u root -p
