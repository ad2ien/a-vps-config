#!/bin/bash

set -e

cd {{ app_path }}/{{ tenant }}/dolibarr
source .env
docker compose exec db mariadb-dump -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} | gzip > dolibar-{{ tenant }}.sql.gz
