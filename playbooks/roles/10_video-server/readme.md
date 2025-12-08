# Video monitoring solution

## Mediamtx

### configure

Fill the parameters

- mediamtx_user
- mediamtx_password

Used to write and read from the server.

### Stream something

With ffmpeg for example

```bash
ffmpeg -i /dev/video0 -f rtsp -rtsp_transport tcp \
rtsps://$USER:$PASSWORD@$BASE_URL:8322/live.sdp
```

you can read it with

```bash
ffplay rtsps://$USER:$PASSWORD@$BASE_URL:8322/live.sdp
```

