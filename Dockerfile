FROM ubuntu:14.04

MAINTAINER Philippe Gibert <philippe.gibert@gmail.com>

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python-software-properties\
                       software-properties-common\
                       curl\
                       wget\
                       make\
                       aptitude\
                       ntp

RUN echo "Europe/Berlin" > /etc/timezone

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list


#install and config of php-fpm 5.6
RUN add-apt-repository ppa:ondrej/php5-5.6
RUN apt-get update
RUN apt-get install -y --force-yes php5-fpm\
                                   php5-cli\
                                   php5-mcrypt\
                                   php-apc\
                                   php-pear\
                                   php5-xdebug

RUN apt-get install -y --force-yes php5-curl
RUN apt-get install -y --force-yes php5-imagick php5-gd
RUN apt-get install -y --force-yes nginx

#composer
RUN bash -c "wget http://getcomposer.org/composer.phar && mv composer.phar /bin/composer"
RUN chmod +x /bin/composer


RUN sed -i "s/;date.timezone =.*/date.timezone = Europe\/Berlin/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = Europe\/Berlin/" /etc/php5/cli/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

# install and config of nginx
RUN echo "daemon on;" >> /etc/nginx/nginx.conf
EXPOSE 80

#add usermode to run nginx
RUN usermod -u 1000 www-data

#add volume
VOLUME ["/data"]
WORKDIR /data

# clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD docker/ntp   /etc/ntp.conf
ADD docker/nginx-site-default   /etc/nginx/sites-available/default
ADD docker/init.sh /init.sh
RUN chmod +x /init.sh

# docker run, /bin/bash is for keep running the container
ENTRYPOINT  /init.sh &&\
            /bin/bash
