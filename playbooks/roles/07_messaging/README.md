# Matrix

## webhook

### register

Send the content of registratio.yml file in your Matrix admin room:
```txt
!admin appservices register
\```
registration_file.content
\```
```

### Create a webhook

Invite `@hookshot:im.domain.com` to a room, then send:

```
!admin users force-join-room @hookshot:domain.com !ROOMID
```

```
!admin users make-user-admin hookshot
```

promote @hookshot to room moderator (with element)

```
!hookshot webhook alertmanager
```

The bot sends you a unique URL like:

```
https://hook.im.domain.com/webhook/abc123...
```

### Configure Alertmanager

```yaml
receivers:
  - name: matrix
    webhook_configs:
      - url: "https://hook.im.domain.com/webhook/abc123..."
        send_resolved: true
```
