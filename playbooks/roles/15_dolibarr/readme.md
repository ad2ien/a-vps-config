# Dolibarr

Install self hosted Dolibarr instance

<https://www.dolibarr.org/>

Login : admin / admin change the password

A database dump every day will be picked up by restic

## restore db

```bash
source .env

gunzip < dolibar-{{ tenant }}.sql.gz | docker compose exec -T db mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}
```