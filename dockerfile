# Usa la imagen oficial de PHP 8.2 con FPM
FROM php:8.2-fpm

ARG user=laravel
ARG uid=1000

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    zip \
    redis \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip pdo_mysql mbstring exif pcntl bcmath gd opcache intl sockets \
    && pecl install redis \
    && docker-php-ext-enable redis zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "Creando usuario con UID=${uid} y nombre=${user}" && \
    useradd -u ${uid} -ms /bin/bash -g www-data ${user}

WORKDIR /var/www

COPY ./docker-compose/php/local.ini /usr/local/etc/php/conf.d/local.ini

COPY --chown=$user:www-data . /var/www

RUN chown -R $user:www-data /var/www

USER $user
EXPOSE 9000
CMD ["php-fpm"]