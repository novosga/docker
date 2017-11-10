FROM php:7.1-apache

ENV NOVOSGA_VER v2.0.0-BETA2
ENV NOVOSGA_MD5 2ce674a0c9ce97473fd9064f23b12e26
ENV NOVOSGA_URL https://github.com/novosga/novosga/archive/${NOVOSGA_VER}.tar.gz
ENV NOVOSGA_FILE novosga.tar.gz
ENV NOVOSGA_DIR /var/www/novosga

ARG APP_ENV=prod
ARG DATABASE_PASS=123456
ARG DATABASE_URL=mysql://root@127.0.0.1:3306/novosga?charset=utf8mb4&serverVersion=5.7

RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
        libxml2-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install \
  intl \
  pcntl \
  pdo \
  pdo_mysql \
  xml \
  zip

RUN set -xe \
    && curl -fSL ${NOVOSGA_URL} -o ${NOVOSGA_FILE} \
    && echo "${NOVOSGA_MD5}  ${NOVOSGA_FILE}" | md5sum -c \
    && tar -xz --strip-components=1 -f ${NOVOSGA_FILE} \
    && rm ${NOVOSGA_FILE}

RUN set -xe \
    && curl -fSL https://getcomposer.org/composer.phar -o composer.phar \
    && php composer.phar install --no-dev

RUN set -xe \
    && chown -R www-data:www-data . \
    && sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf \
    && echo \
'Options -MultiViews\n\
RewriteEngine On\n\
RewriteCond %{REQUEST_FILENAME} !-f\n\
RewriteRule ^(.*)$ index.php [QSA,L]\n\
PassEnv APP_ENV\n\
PassEnv DATABASE_URL\n\
PassEnv DATABASE_PASS' > public/.htaccess

RUN a2enmod rewrite env
