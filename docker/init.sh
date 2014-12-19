#!/bin/bash

#start services
service ntp start
service php5-fpm start
service nginx start


#init application
#cd /data/app
#composer update

