# FRP

## Use case

There's a server using the camera running on an Android device that I want to access from the internet.

browser <- https -> traefik basic auth <-> frps container <-> frpc android device <-> android server app

## Basic auth

Create password

```bash
echo $(htpasswd -nB user) | sed -e s/\\$/\\$\\$/g
```

## FRPS

Full configuration : <https://github.com/fatedier/frp/blob/dev/conf/frps_full_example.toml>

Needs a port for communication between frpc and frps and and other port to serve the actual tunneled application.

## Device

Configure device

- Install [termux](https://termux.dev/en/)
- setup ssh and connect to your device
- run this script to install frpc

  ```bash
  FRP_VERSION=0.61.2
  pkg install wget

  wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_arm.tar.gz 
  tar -xvf frp_${FRP_VERSION}_linux_arm.tar.gz
  ```

- Config `./frpc.toml` file

  ```toml
  # server ip
  serverAddr = "x.x.x.x"
  # server port
  serverPort = {{frps_port}}

  auth.method = "token"
  auth.token = "{{frps_auth_token}}"
  
  # configure your local server
  [[proxies]]
  name = "web"
  type = "http"
  localIP = "127.0.0.1"
  localPort = 8080
  customDomains = ["{{frps_subdomain}}.domain"]
  ```

Full configuration : <https://github.com/fatedier/frp/blob/dev/conf/frpc_full_example.toml>

- run

  ```bash
  nohup ./frpc -c ./frpc.toml >/dev/null 2>&1 &
  ```

### TODO

- [ ] run automatically
