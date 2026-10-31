#!/bin/bash

stack() {
  source .env
  docker run \
  -v ${HOST_STACK_CONF_PATH}:/backup-repo \
  -v ./rclone.conf:/root/.config/rclone/rclone.conf:ro \
  -e RESTIC_REPOSITORY=rclone:${RCLONE_CONFIGURATION_NAME}:${PCLOUD_STACK_REPO} \
  -e RESTIC_PASSWORD=${RESTIC_PASSWORD} \
  --rm --env-file .env mazzolino/restic:${IMAGE_VERSION} "$@"
}

volume() {
  source .env
  docker run \
  -v ${HOST_SOURCE_BACKUP}:/backup-repo \
  -v ./rclone.conf:/root/.config/rclone/rclone.conf:ro \
  -e RESTIC_REPOSITORY=rclone:${RCLONE_CONFIGURATION_NAME}:${PCLOUD_REPO} \
  -e RESTIC_PASSWORD=${RESTIC_PASSWORD} \
  --rm --env-file .env mazzolino/restic:${IMAGE_VERSION} "$@"
}

"$@"
