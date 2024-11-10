# Rclone / pcloud

## Make rclone conf

on a internet browser available environment : <https://rclone.org/pcloud/>

```bash
rclone config
```

You should get a rclone.conf file, surely in `~/.config/rclone/rclone.conf`

Copy it in the current folder

### Alias

Make an alias for convenience

```bash
alias restic-util="docker compose -f docker-compose-utils.yml run --rm"
```

## Init Restic Repo

```bash
restic-util restic-init
```

fill `.env` with password

## Start service

```bash
docker compose up -d
```

## List Snapshots

```bash
restic-util restic-list-snapshots
```

## Restore

- Make sur to have all the input before doing anything <https://restic.readthedocs.io/en/stable/050_restore.html>
- Edit restic-restore service depending on what you want to restore

```bash
restic-util restic-restore
```
