#!/usr/bin/env sh

echo "Setting up Messenger transports: async"
php bin/console messenger:setup-transports

while true
do
    echo "Starting Messenger Consumer: async"
    php bin/console messenger:consume async -vv --time-limit=3600
    echo "Consumer stopped (time-limit achived)"
done
