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

## Shinobi

For this to work Shinobi image should be published somewhere :

```bash
git clone https://gitlab.com/Shinobi-Systems/ShinobiDocker.git
cd ShinobiDocker
docker buildx build . -t $REGISTRY_SUBDOMAIN.$YOUR_DOMAIN/shinobi:latest
docker login $REGISTRY_SUBDOMAIN.$YOUR_DOMAIN
docker push $REGISTRY_SUBDOMAIN.$YOUR_DOMAIN/shinobi:latest
```

So far rtsp works but no rtsps

go to `shinobi.your-url.com/super` doc here : <https://docs.shinobi.video/>
