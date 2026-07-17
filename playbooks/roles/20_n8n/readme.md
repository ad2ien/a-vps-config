# n8n

<https://n8n.io/>

[MatrixNotif.json](MatrixNotif.json) contains a worflow that creates a webhook to send a matrix message to a specific room.


Just
- configure matrix step with a token
- replace WEBHOOK_ID with a guid
- publish it and use as webhook:

```url
https://n8n.domain.com/webhook/webhookid?type=dockhandORalertmanager&room=ROOMIDwithout!anddomain
```
