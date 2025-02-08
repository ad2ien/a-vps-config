# Rclone / pcloud

## Make rclone conf

On an internet browser available environment : <https://rclone.org/pcloud/>

```bash
rclone config
```

You should get a rclone.conf file, surely in `~/.config/rclone/rclone.conf`

Copy it in the current folder

### Alias

Make aliases for convenience:

```bash
alias stackrestic="source .env && docker run \
-v ${HOST_STACK_CONF_PATH}:/backup-repo \
-v ./rclone.conf:/root/.config/rclone/rclone.conf:ro \
-e RESTIC_REPOSITORY=rclone:${RCLONE_CONFIGURATION_NAME}:${PCLOUD_STACK_REPO} \
-e RESTIC_PASSWORD=${RESTIC_PASSWORD} \
--rm --env-file .env mazzolino/restic:${IMAGE_VERSION}"
```

```bash
alias volumerestic="source .env && docker run \
-v ${HOST_SOURCE_BACKUP}:/backup-repo \
-v ./rclone.conf:/root/.config/rclone/rclone.conf:ro \
-e RESTIC_REPOSITORY=rclone:${RCLONE_CONFIGURATION_NAME}:${PCLOUD_REPO} \
-e RESTIC_PASSWORD=${RESTIC_PASSWORD} \
--rm --env-file .env mazzolino/restic:${IMAGE_VERSION}"
```

## Init Restic Repo

```bash
stackrestic init
volumerestic init
```

fill `.env` with password

## Start service

```bash
docker compose up -d
```

## List Snapshots

```bash
stackrestic snapshots
```

## List Snapshots files

```bash
stackrestic ls --long SNAPHOT_ID
```

## Restore

- Make sur to have all the input before doing anything <https://restic.readthedocs.io/en/stable/050_restore.html>
- Edit restic-restore service depending on what you want to restore. Ex:

```bash
volumerestic restore --include /backup-repo/VOLUME/_data/config --target / SNAPHOT_ID
```
