FROM php:8.1.5-apache
RUN a2enmod rewrite

RUN apt-get update \
  && apt-get install openssh-client \
  && apt-get install -y libzip-dev git wget --no-install-recommends \
  && apt-get install -y libpq-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 
RUN docker-php-ext-install pdo mysqli pdo_pgsql pgsql zip;

RUN wget https://getcomposer.org/download/2.0.9/composer.phar  \
    && mv composer.phar /usr/bin/composer  \
    && chmod +x /usr/bin/composer

COPY docker/.bashrc ~/.bashrc
COPY docker/apache.conf /etc/apache2/sites-enabled/000-default.conf

RUN git clone https://${DOCKER_GIT_TOKEN}@github.com/r4ckham/sf-server.git .
RUN composer install

COPY . /var/www/

WORKDIR /var/www

CMD ["apache2-foreground"]
