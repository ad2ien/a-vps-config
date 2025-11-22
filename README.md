# A VPS docker compose config

[![Lint workflow status](https://img.shields.io/github/actions/workflow/status/ad2ien/a-vps-config/lint.yml?label=lint&logo=github)](https://ad2ien.github.io/a-vps-config)
[![Docker](https://img.shields.io/badge/Docker-compose-2496ED.svg?logo=Docker)](https://www.docker.com/)
[![Gitmoji](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg)](https://gitmoji.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

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

## Deployment

- [Ansible](https://docs.ansible.com/)

Setup vps configuration in `host_vars`

Then

```bash
ansible-playbook playbooks/full-install.yml -i inventory/hosts.yml --diff
```

⚠️ IN PROGRESS

### TODO

- [ ] playbook to manage wireguard conf and certificates
- [ ] update and fix images versions
- [ ] Import grafana dashboards
- [ ] Migrate from promtail to grafana alloy

## use

- configure when needed depending on the service
- env var should at least contain:

  ```bash
  TRAEFIK_NETWORK=traefik_net
  DOMAIN=YOUR.DOMAIN.NAME
  ```

For exemple with `.env` files
