FROM php:8.2.12-cli-bullseye

ENV TZ=Asia/Karachi
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y gpg && \
    curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
    systemctl \
    curl \
    cron \
    zip \
    unzip \
    zlib1g-dev \
    libicu-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    supervisor \
    redis \
    redis-server \
    redis-tools && \
    systemctl enable redis-server --now

RUN pecl install redis swoole
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath gd intl soap
RUN docker-php-ext-enable redis swoole
RUN docker-php-ext-configure intl

RUN sed -i -e "s/upload_max_filesize = .*/upload_max_filesize = 1G/g" \
        -e "s/post_max_size = .*/post_max_size = 1G/g" \
        -e "s/memory_limit = .*/memory_limit = 512M/g" \
        /usr/local/etc/php/php.ini-production \
        && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

COPY . /var/www

WORKDIR /var/www

COPY ./horizon.conf /etc/supervisor/conf.d/
RUN systemctl enable supervisor

RUN rm -r /var/www/html
RUN rm /var/www/octane.conf
RUN rm /var/www/horizon.conf

RUN chmod +x start

ENTRYPOINT ["/var/www/start"]

EXPOSE 8000