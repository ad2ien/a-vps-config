# A VPS docker compose config

## Stack

- [Docker / docker compose](https://www.docker.com/)
- [Traefik](https://doc.traefik.io/)
- [Portainer](https://www.portainer.io/)
- [Prometheus/Grafana](https://grafana.com/)

- Some tools
  - [Nextcloud](https://nextcloud.com/)
  - [Wireguard](https://www.wireguard.com/)
  - [Conduit](https://conduit.rs/) (Matrix messaging)
- and also used as playground to test or temporary use various projects

## Requirements

- a linux VPS
- docker / docker compose installed
- a domain pointing to this VPS

## use

- configure when needed depending on the service
- env var should at least contain:

  ```bash
  TRAEFIK_NETWORK=traefik_net
  DOMAIN=YOUR.DOMAIN.NAME
  ```

For exemple with `.env` files
