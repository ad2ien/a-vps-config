#!/bin/bash
set -e

echo "Check docker versions..."

# get all docker-compose.yml files
folders=$(ls -d /srv/*)
echo $folders

# loop over all docker-compose.yml files
for folder in $folders; do
  docker_compose_file="$folder/docker-compose.yml"
  if [ ! -f "$docker_compose_file" ]; then
    continue
  fi

  echo "Checking $folder"
  while IFS= read -r line; do
    line=$(echo "$line" | tr -d '[:space:]')
    if [[ $line == *"image:"* && $line != \#* ]]; then
      image_name=$(echo $line | sed "s/image://g" | tr -d '[:space:]' | sed "s/:.*//g")
      image_version=$(echo $line | sed "s/image: //g" | sed "s/.*://g")
      echo "  Image $image_name version $image_version"
    fi
  done < "$docker_compose_file"

done
