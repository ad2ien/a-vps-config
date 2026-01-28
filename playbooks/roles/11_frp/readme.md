# FRP

Doc : <https://github.com/fatedier/frp>

## Ssh distant login

Ssh login to a local device from anywhere

### FRPS client

On your device like a local server or a raspberry.

```toml
# frpc.toml
serverAddr = {{domain}}
serverPort = {{frps_port}}

auth.method = "token"
auth.token = "{{frps_auth_token}}"

[[proxies]]
name = "ssh1"
type = "tcpmux"
multiplexer = "httpconnect"
customDomains = ["any.madeup.url"]
localIP = "127.0.0.1"
localPort = 22
```

Install the right binary <https://github.com/fatedier/frp/releases>

Start the process

```bash
./frpc -c frpc.toml
```

### Connect from anywhere

Install [socat](https://linux.die.net/man/1/socat)

```bash
ssh -o 'proxycommand socat - PROXY:{{domain}}:%h:%p,proxyport={{frps_tcpmux_port}}' user@any.madeup.url
```

## Https server access

There's a server using running on an Android or raspberry device that you want to access from the internet.

browser <- https -> traefik basic auth <-> frps container <-> frpc device <-> device server app

### Basic auth

Create password

```bash
echo $(htpasswd -nB user) | sed -e s/\\$/\\$\\$/g

### Android FRPS Device

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

- run

  ```bash
  nohup ./frpc -c ./frpc.toml >/dev/null 2>&1 &
  ```
