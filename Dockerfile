FROM phpswoole/swoole:5.1-php8.2

ENV TZ=Asia/Karachi
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y

RUN docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install \
    pcntl

COPY . /var/www

WORKDIR /var/www

COPY ./octane.conf /etc/supervisor/conf.d/
RUN /bin/bash -c supervisorctl reread && \
    /bin/bash -c supervisorctl update

RUN rm -r /var/www/html
RUN rm /var/www/server.php
RUN rm /var/www/octane.conf

EXPOSE 8000