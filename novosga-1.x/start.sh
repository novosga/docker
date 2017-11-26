#!/bin/sh

WORKDIR="/var/www/html"

# DATABASE_HOST=mysqldb DATABASE_NAME=novosga DATABASE_USER=root DATABASE_PASSWORD=teste DATABASE_DRIVER=mysql NOVOSGA_ADMIN_USERNAME="admin" NOVOSGA_ADMIN_FIRSTNAME="fulano" NOVOSGA_ADMIN_LASTNAME="beltrano sicrano" NOVOSGA_ADMIN_PASSWORD="teste" VERSION="1.5.0" DATABASE_SGDB=mysql PORT=3306 teste/start.sh

echo "Starting pre-flight check... "

echo -n "Database driver: "
case $DATABASE_SGDB in
        mysql)
                export DATABASE_DRIVER="pdo_mysql"
                echo "Ok, set as mysql"
                ;;
        postgres)
                export DB_DRIVER="pdo_postgres"
                echo "Ok, set as postgres"
                ;;
        *)
                echo "Error - SGDB must be either 'mysql' or 'postgres'"
		exit 1
                ;;
esac

echo -n "Database host: "
if [ -z "$DATABASE_HOST" ]; then
  echo "You need to tell me where to find the database with DB_HOST"
  exit 1
fi
echo "Ok"

echo -n "Database user: "
if [ -z "$DATABASE_USER" ]; then
  echo "You need to tell me the user to connect to your database with DB_USER"
  exit 1
fi
echo "Ok"


echo -n "Database password: "
if [ -z "$DATABASE_PASSWORD" ]; then
  echo "You neet to tell me the password to connect to your database with DB_PASSWORD"
  exit 1
fi
echo "Ok"

echo "Pre-flight check done"

cat >$WORKDIR/config/database.php <<EOF
<?php
return array(
    "driver" => "$DATABASE_DRIVER",
    "host" => "$DATABASE_HOST",
    "port" => "$DATABASE_PORT",
    "user" => "$DATABASE_USER",
    "password" => "$DATABASE_PASSWORD",
    "dbname" => "$DATABASE_NAME",
    "charset" => "utf8",
);
EOF

#get the version of the app :)
export VERSION=$(grep 'VERSION =' src/Novosga/App.php | sed -r 's/[^0-9.]*([0-9.]+)[^0-9.]*/\1/')

start_db.php

echo "Setup is done, starting Apache..."
exec apache2-foreground
