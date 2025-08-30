#!/bin/bash
set -e

echo "Start stopping..."

# list folders
folders=$(ls -d /srv/*)

# loop over all docker-compose.yml files
for folder in $folders; do
  echo $folder
  # if docker compose file exists
  if [ -f "$folder/docker-compose.yml" ]; then
    echo "Stopping $folder"
    docker compose  -f "$folder/docker-compose.yml" down
  fi
done

echo "All stacks stopped"
