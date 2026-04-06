# A simple VPS IaC

[![Lint workflow status](https://img.shields.io/github/actions/workflow/status/ad2ien/a-vps-config/lint.yml?label=lint&logo=github)](https://ad2ien.github.io/a-vps-config)
[![Docker](https://img.shields.io/badge/devops-Docker%20compose-2496ED.svg?logo=Docker)](https://www.docker.com/)
[![Ansible](https://img.shields.io/badge/devops-Ansible-EE0000.svg?logo=Ansible)](https://www.ansible.com/)
[![Gitmoji](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg)](https://gitmoji.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Stack

- [Docker / docker compose](https://www.docker.com/)
- [Traefik](https://doc.traefik.io/) - reverse proxy
- [Portainer](https://www.portainer.io/) - container management
- [Prometheus/Grafana](https://grafana.com/) - Observation / alerting
- [Restic](https://restic.net/) - backup
- Some tools:

  | Service                                                               | Description                                  |
  | --------------------------------------------------------------------- | -------------------------------------------- |
  | [Nextcloud](https://nextcloud.com/)                                   | File synchronization and sharing platform    |
  | [Wireguard](https://www.wireguard.com/)                               | VPN and secure network tunnel                |
  | [Conduit](https://conduit.rs/)                                        | Matrix messaging protocol server             |
  | [Mediamtx](https://mediamtx.org/) / [Shinobi](https://shinobi.video/) | Video monitoring and streaming               |
  | [Docker Registry](https://hub.docker.com/_/registry)                  | Private Docker image registry                |
  | [Rustdesk](https://rustdesk.com/)                                     | Remote desktop access tool                   |
  | [Superset](https://superset.apache.org/)                              | Data visualization and business intelligence |
  | [Dolibarr](https://www.dolibarr.org/)                                 | ERP and CRM software                         |
  | [Checkmate](https://github.com/bluewave-labs/checkmate)               | Uptime monitoring and alerting               |

- and also used as playground to test or temporary use various projects

## Requirements

- a linux VPS
- docker / docker compose installed
- a domain pointing to this VPS

### Ansible modules

- docker
- crypto

```bash
ansible-galaxy collection install community.docker community.crypto
```

- Setup vps configuration in `host_vars`
- make and fill `private.yml` based on `private.yml.template` depending on your needs

Then

```bash
ansible-playbook playbooks/full-install.yml  -i inventory/hosts.yml -t $TOOL --diff --check
```

$TOOL tag from there : [full-install.yml](./full-install.yml)

## ⚠️ IN PROGRESS

### TODO

- [ ] playbook to manage wireguard conf and certificates
- [ ] Import grafana dashboards
- [ ] Migrate from promtail to grafana alloy
