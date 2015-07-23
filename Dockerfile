FROM nuagebec/ubuntu:14.04
MAINTAINER David Tremblay <david@nuagebec.ca>

#install php and apache

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -yq install \
        postfix \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-gd \
        php5-curl \
        php-pear \
	php5-mcrypt \
        php-mail \
        mysql-client \
        php-apc \
        php5-dev \ 
	php-pear && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# let's install xdebug
RUN pecl install xdebug

ADD supervisor_apache.conf /etc/supervisor/conf.d/apache.conf 
ADD ./config/php.ini /etc/php5/apache2/conf.d/php.ini
ADD ./config/000-default.conf /etc/apache2/sites-available/000-default.conf

#Activate php5-mcrypt
RUN php5enmod mcrypt

#Activate mod_rewrite
RUN a2enmod rewrite

RUN echo "<?php phpinfo();" > /var/www/html/index.php


EXPOSE 80 443 9000
CMD ["/data/run.sh"]

