#!/bin/bash

echo "Parando Tomcat"
/etc/alternatives/apache-tomcat/bin/shutdown.sh
echo "Iniciando Tomcat"
/etc/alternatives/apache-tomcat/bin/startup.sh
echo "Executando index-update"
/var/www/dspace/bin/index-update
echo "Executando filter-media"
/var/www/dspace/bin/filter-media
echo "Executando update-discovery-index"
/var/www/dspace/bin/dspace update-discovery-index

