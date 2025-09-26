# Nextcloud config

## Talk

Activate Talk module. In `https://nextcloud.DOMAIN/settings/admin/talk`. Set the following:

- High-performance backend `https://nc-signaling.DOMAIN` and `nextcloud_turn_signaling_secret`
- add a TURN server : `turn: only`, `DOMAIN:3478`, `nextcloud_turn_secret`, `UDP and TCP`

## Backup and retention management

Use case : Backup Podcast Addict app on Android and have a retention period

### On the smartphone

- Podcast Addict configured to save a backup every night in `Document/Backup/PoddcastAddict`
- Nextcloud Android client
  - configured to automatically upload the content of `Document/Backup/PoddcastAddict` in `Backup/PodcastAddict`

### Nextcloud

Install the following plugin :

- Retention <https://github.com/nextcloud/files_retention>
- files_automatedtagging <https://github.com/nextcloud/files_automatedtagging>

- In Administration Flow / File Retention and automatic deletion:  
  Create a tag `retention` and a retention period
- As a user : Settings / Flow:  
  Create : When file change matches `/^PodcastAddict_.*/` automated tagging : `retention`
