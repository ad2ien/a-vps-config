# A simple VPS IaC

[![Docker](https://img.shields.io/badge/devops-Docker%20compose-2496ED.svg?logo=Docker)](https://www.docker.com/)
[![Ansible](https://img.shields.io/badge/devops-Ansible-EE0000.svg?logo=Ansible)](https://www.ansible.com/)
[![Gitmoji](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg)](https://gitmoji.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Stack

- [Docker / docker compose](https://www.docker.com/)
- [Traefik](https://doc.traefik.io/) - reverse proxy
- [Dockhand](https://dockhand.pro/) - container management
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
  | [Paheko](https://paheko.cloud/)                                       | Manage associations                          |
  | [Moodle](https://moodle.org/)                                         | E-learning plateform                         |

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

## Setup

- create a vault-pw file with a password
- Setup vps configuration in `secrets` based on `secrets-template`
- Crypt all this with ansible-vault : `find . -path "*.git*" -prune -o -type f -printf "%h/\"%f\" " | xargs ansible-vault encrypt --vault-password-file=../vault-pw`
- make and fill `private.yml` based on `private.yml.template` depending on your needs

$TOOL tag from there : [full-install-master.yml](./full-install-master.yml) or `-private` for private server tools.

### If tenant specific

- fill secrets/tenants/tenant.yml with vars from `ROLE/default/main.yml`

## Run

```bash
ansible-playbook playbooks/full-install-master.yml -t ROLE -e @secrets/tenants/TENANT.yaml --diff --vault-password-file=vault-pw --check
```
