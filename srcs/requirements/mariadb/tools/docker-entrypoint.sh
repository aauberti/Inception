#!/bin/bash
echo "Initiate the DB"

set -e

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo "Error: MYSQL_ROOT_PASSWORD is not set"
    exit 1
fi

if [ -z "$MYSQL_DATABASE" ]; then
    echo "Error: MYSQL_DATABASE is not set"
    exit 1
fi

if [ -z "$MYSQL_USER" ]; then
    echo "Error: MYSQL_USER is not set"
    exit 1
fi

if [ -z "$MYSQL_PASSWORD" ]; then
    echo "Error: MYSQL_PASSWORD is not set"
    exit 1
fi

echo "All variables are set"

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "First initialization - Setting up MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Generating SQL initialization file..."
    SQL_FILE="/tmp/init.sql"

    echo "FLUSH PRIVILEGES;" > "$SQL_FILE"
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;" >> "$SQL_FILE"
    echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> "$SQL_FILE"
    echo "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';" >> "$SQL_FILE"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" >> "$SQL_FILE"
    echo "FLUSH PRIVILEGES;" >> "$SQL_FILE"

    echo "Starting MariaDB temporarily..."
    mysqld --user=mysql --bootstrap < "$SQL_FILE"

    rm "$SQL_FILE"
else
    echo "MariaDB already initialized"
fi

#Pour pouvoir écouter d'autre port et pas que localhost
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

echo "Creating socket directory..."
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

echo "Starting MariaDB server..."
exec mysqld --user=mysql