#!/bin/bash
set -e

# This should be run in a crontab task
# Send a matrix message if last backup is older than 24h

source .env

echo "Start backup logger"
echo "---"
echo "Log last restic snapshots, used to make a an alert with grafana if backup isn't working properly"
echo ""

notify_mx() {
  local message="$1"
  
  local token=$(curl -s -X POST \
    "${MATRIX_HOMESERVER}/_matrix/client/v3/login" \
    -H "Content-Type: application/json" \
    -d "{
      \"type\": \"m.login.password\",
      \"identifier\": {
        \"type\": \"m.id.user\",
        \"user\": \"${MATRIX_USERNAME}\"
      },
      \"password\": \"${MATRIX_PASSWORD}\",
      \"initial_device_display_name\": \"Backup Logger\"
    }" \
    | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
  
  if [ -z "$token" ]; then
    echo "Failed to authenticate with Matrix"
    return 1
  fi
  
  echo "Send message..."
  local txn_id=$(date +%s)
  curl -X PUT \
    "${MATRIX_HOMESERVER}/_matrix/client/v3/rooms/${MATRIX_BACKUP_ROOM_ID}/send/m.room.message/${txn_id}?access_token=${token}" \
    -H "Content-Type: application/json" \
    -d "{\"msgtype\": \"m.text\", \"body\": \"${message}\"}"
}

stackrestic="source .env && docker run \
-v ${HOST_STACK_CONF_PATH}:/backup-repo \
-v ./rclone.conf:/root/.config/rclone/rclone.conf:ro \
-e RESTIC_REPOSITORY=rclone:${RCLONE_CONFIGURATION_NAME}:${PCLOUD_STACK_REPO} \
-e RESTIC_PASSWORD=${RESTIC_PASSWORD} \
--rm --env-file .env mazzolino/restic:${IMAGE_VERSION}"

volumerestic="source .env && docker run \
-v ${HOST_SOURCE_BACKUP}:/backup-repo \
-v ./rclone.conf:/root/.config/rclone/rclone.conf:ro \
-e RESTIC_REPOSITORY=rclone:${RCLONE_CONFIGURATION_NAME}:${PCLOUD_REPO} \
-e RESTIC_PASSWORD=${RESTIC_PASSWORD} \
--rm --env-file .env mazzolino/restic:${IMAGE_VERSION}"

get_last_snapshot() {
  eval "$@ unlock"
  eval "$@ snapshots -c --latest 1" | grep -E "^[a-f0-9]{8}" | tail -1 | awk '{print $2, $3}'
}

check_backup_age() {
  local backup_time="$1"
  local backup_name="$2"

  # Convert backup_time to seconds since epoch
  local backup_epoch=$(date -d "$backup_time" +%s 2>/dev/null)
  local current_epoch=$(date +%s)
  local age_hours=$(( (current_epoch - backup_epoch) / 3600 ))

  if [ "$age_hours" -gt 24 ]; then
    notify_mx " WARNING: ${backup_name} backup is ${age_hours}h old!"
    return 1
  else
    echo "${backup_name} backup is recent (${age_hours}h old)"
    return 0
  fi
}

echo "Run backup test..."
lastResticDate=$(get_last_snapshot $stackrestic)
echo "lastResticDate : $lastResticDate"
check_backup_age "$lastResticDate" "Stack"

volumeresticDate=$(get_last_snapshot $volumerestic)
echo "volumeresticDate : $volumeresticDate"
check_backup_age "$volumeresticDate" "Volume"

echo "-- end test"
