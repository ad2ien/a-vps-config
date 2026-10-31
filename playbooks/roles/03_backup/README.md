# Rclone / pcloud

## Make rclone conf

On an internet browser available environment : <https://rclone.org/pcloud/>

```bash
rclone config
```

You should get a rclone.conf file, surely in `~/.config/rclone/rclone.conf`

Copy it in the current folder

## Init Restic Repo

fill `.env` with password

```bash
./restic.sh stack init
./restic.sh volume init
```

## Start service

```bash
docker compose up -d
```

## List Snapshots

```bash
./restic.sh stack snapshots
```

## List Snapshots files

```bash
./restic.sh stack ls --long SNAPHOT_ID
```

## Restore

- Make sur to have all the input before doing anything <https://restic.readthedocs.io/en/stable/050_restore.html>
- Edit restic-restore service depending on what you want to restore. Ex:

```bash
./restic.sh volume restore --include /backup-repo/VOLUME/_data/config --target / SNAPHOT_ID
```
