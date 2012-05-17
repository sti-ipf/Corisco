#!/bin/bash

echo "Parando Tomcat"
/etc/alternatives/apache-tomcat/bin/shutdown.sh
echo "Iniciando Tomcat"
/etc/alternatives/apache-tomcat/bin/startup.sh
echo "Executando index-update"
/var/dados/dspace/bin/index-update
echo "Executando filter-media"
/var/dados/dspace/bin/filter-media
echo "Executando update-discovery-index"
/var/dados/dspace/bin/dspace update-discovery-index

