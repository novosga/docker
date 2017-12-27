#!/bin/sh
echo "Starting pre-flight check..."

echo -n "Database url: "
if [ -z "$DATABASE_URL" ]; then
    echo "\nYou need to tell me where the database is and how to connect to it by setting DATABASE_URL environment variable"
    echo "e.g.: Using the flag -e DATABASE_URL='mysql://user:pass@127.0.0.1:3306/dbname?charset=utf8mb4&serverVersion=5.7' at docker container run"
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

echo "Setup done! Starting apache"
exec /usr/bin/supervisord -n
