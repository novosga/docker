FROM composer/composer:1.1-php5-alpine as build

ENV NOVOSGA_VER=v1.5.1 \
    NOVOSGA_MD5=a201469188d7209c20a473f34a1c2d21

ENV NOVOSGA_FILE=novosga.tar.gz \
    NOVOSGA_DIR=/var/www/html \
    NOVOSGA_URL=https://github.com/novosga/novosga/archive/${NOVOSGA_VER}.tar.gz

WORKDIR $NOVOSGA_DIR

RUN set -xe \
    && apk add --no-cache gettext-dev gettext tar \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pcntl \
    && curl -fSL ${NOVOSGA_URL} -o ${NOVOSGA_FILE} \
    && echo "${NOVOSGA_MD5}  ${NOVOSGA_FILE}" | md5sum -c \
    && tar -xz --strip-components=1 -f ${NOVOSGA_FILE} \
    && rm ${NOVOSGA_FILE} \
    && composer install --no-dev

FROM php:5.6.24-apache

EXPOSE 80

RUN echo 'session.save_path = "/tmp"' > /usr/local/etc/php/conf.d/sessionsavepath.ini && \
    echo 'date.timezone = ${TZ}' > /usr/local/etc/php/conf.d/datetimezone.ini

RUN apt-get update \
    && apt-get install -y postgresql-server-dev-all --no-install-recommends \
    && docker-php-ext-install gettext pdo_mysql pdo_pgsql \
    && a2enmod rewrite \
    && apt-get remove -y --purge postgresql-server-dev-all \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=build /var/www/html /var/www/html

RUN echo "RedirectMatch ^/$ /public" > .htaccess \ 
    && chown -R 33:33 /var/www/html

#set default env vars
ENV TZ="UTC" \
    DATABASE_NAME="novosga" \
    NOVOSGA_ADMIN_USERNAME="admin" \
    NOVOSGA_ADMIN_FIRSTNAME="Administrator" \
    NOVOSGA_ADMIN_LASTNAME="Global" \
    NOVOSGA_ADMIN_PASSWORD="123456" \
    DATABASE_PORT="3306"

COPY start.sh /bin

COPY start_db.php /bin

CMD ["start.sh"]
