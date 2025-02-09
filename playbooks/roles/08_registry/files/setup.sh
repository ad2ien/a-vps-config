#!/bin/bash
set -e

mkdir -p auth
source .env

docker run --rm \
  --entrypoint htpasswd \
  httpd:2 -Bbn $REGISTRY_AUTH_USER $REGISTRY_AUTH_PW > auth/htpasswd
