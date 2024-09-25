#!/bin/bash
set -ae

sudo apt update
sudo apt install apache2-utils -y
mkdir auth
cd auth
source .env
htpasswd -Bc registry.password $REGISTRY_AUTH_HTPASSWD_REALM
