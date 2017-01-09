FROM ubuntu:trusty
MAINTAINER NJ Darda <jedrekdarda@gmail.com>

RUN apt-get update && apt-get -y install software-properties-common python-software-properties
RUN locale-gen en_US.UTF-8 && export LANG=en_US.UTF-8 && export LC_ALL=en_US.UTF-8 && add-apt-repository -y ppa:ondrej/php

# Install base packages
RUN apt-get update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
	php5.6 \
        php5.6-common \
        libapache2-mod-php5.6 \
        php5.6-cli \
        php5.6-curl \
        php5.6-xdebug \
        php5.6-imagick \
        php5.6-mysql \
        php5.6-pgsql \
        php5.6-redis \
        php5.6-mcrypt \
	php5.6-mbstring \
        php5.6-intl \
	php5.6-gd \
	php5.6-zip \
        php5.6-memcache \
	git \
        vim \
	zip \
	unzip \
	php5.6-xml \
	php5.6-simplexml

RUN rm -rf /var/lib/apt/lists/*

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# debugger setup
RUN echo "xdebug.remote_enable=1" >> /etc/php/5.6/apache2/php.ini
RUN echo "xdebug.remote_host=10.0.2.2" >> /etc/php/5.6/apache2/php.ini # 10.0.2.2 is the ip of the host machine on Virtual Box
RUN echo "xdebug.max_nesting_level=250" >> /etc/php/5.6/apache2/php.ini

EXPOSE 80
WORKDIR /share/
RUN chown www-data:www-data /var/www -R

CMD ["/run.sh"]
