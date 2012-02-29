#!/bin/bash

echo "Executando index-update"
/var/dados/dspace/bin/index-update
echo "Executando filter-media"
/var/dados/dspace/bin/filter-media
echo "Executando update-discovery-index"
/var/dados/dspace/bin/dspace update-discovery-index

