# Wireguard

Based on <https://hub.docker.com/r/linuxserver/wireguard>

```bash
docker-compose up -d
```

Then a configuration is generated copy it on your client. Then providing wireguard is installed on a client, for instance :

```bash
wg-quick up /etc/wireguard/peer1.conf
```
