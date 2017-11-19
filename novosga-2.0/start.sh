#!/bin/sh
echo "Starting pre-flight check..."

echo -n "Database url: "
if [ -z "$DATABASE_URL" ]; then
    echo "\nYou need to tell me where the database is and how to connect to it by setting DATABASE_URL environment variable"
    echo "e.g.: Using the flag -e DATABASE_URL='mysql://root@127.0.0.1:3306/novosga?charset=utf8mb4&serverVersion=5.7' at docker container run"
    exit 1
fi
echo "Ok"

echo -n "Database password: "
if [ -z "$DATABASE_PASS" ]; then
    echo "\nYou need to tell me the database password by setting DATABASE_PASS environment variable"
    echo "e.g.: Using the flag -e DATABASE_PASS='password' at docker container run"
    exit 1
fi
echo "Ok"

# we need to wait until the database is up and accepting connections
until bin/console -q doctrine:query:sql "select version()" > /dev/null 2>&1; do 
    echo "Waiting for database..."; 
    sleep 5; 
done

echo "Database is up, configuring schema"

set -xe

#Install/Updates the database schema
/var/www/html/bin/console novosga:install

#Ensures all files have the right owner
chown -R www-data:www-data /var/www/html/*

echo "Setup done! Starting apache"
exec apache2-foreground