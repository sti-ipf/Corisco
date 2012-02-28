#!/bin/bash

echo "Executando index-update"
/dados/dspace/bin/index-update
echo "Executando filter-media"
/dados/dspace/bin/filter-media
echo "Executando update-discovery-index"
/dados/dspace/bin/dspace update-discovery-index

