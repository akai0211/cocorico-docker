#!/bin/sh

if [[ ! -f composer.json ]]; then
    git clone --no-checkout https://github.com/Cocolabs-SAS/cocorico
    mv cocorico/.git .
    rmdir cocorico
    git reset --hard HEAD
fi

if [[ ! -f app/config/parameters.yml ]]; then
    cp /init/parameters.yml app/config/parameters.yml
    php -r "readfile('https://getcomposer.org/installer');" | php
    php composer.phar install --prefer-dist.
    chmod 744 bin/init-db bin/init-mongodb
    ./bin/init-db php --env=dev
    ./bin/init-mongodb php --env=dev
    php bin/console assets:install --symlink web --env=dev
    php bin/console assets:install --symlink web --env=dev
    chmod -R 777 var/cache var/logs
fi
