FROM php:7.1-apache

RUN set -xe \
    && apt-get update \
    && apt-get install -y \
        cron \
        git \
        libcurl3-dev \
        libicu-dev \
        libmcrypt-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libfreetype6-dev \
        libgd2-xpm-dev \
        libxml2-dev \
        zlib1g-dev \
        supervisor \
    && docker-php-ext-configure \
        gd \
        --enable-gd-native-ttf \
        --with-freetype \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
    && docker-php-ext-install \
        curl \
        gd \
        intl \
        pcntl \
        pdo \
        pdo_mysql \
        xml \
        zip \
    && apt-get remove -y --purge \
        postgresql-server-dev-all \
        libicu-dev \
        libxml2-dev \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && a2enmod rewrite env \
    && echo 'session.save_path = "/tmp"' > /usr/local/etc/php/conf.d/sessionsavepath.ini \
    && echo 'date.timezone = ${TZ}' > /usr/local/etc/php/conf.d/datetimezone.ini
