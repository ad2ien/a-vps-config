# Monitoring

## Dashboards

Import dashboards https://grafana.com/grafana/dashboards

## Notifications

in [./playbooks/roles/20_n8n](./playbooks/roles/20_n8n) there's a workflow that creates a webhook to send matrix messages,

```mermaid
flowchart LR
    subgraph dc["Docker containers (stdout/stderr)"]
        TR[Traefik]
        OT[other containers]
    end
    H["/var/log/*log"] --> A
    TR -->|"access logs (JSON)"| A[Alloy]
    OT --> A
    A -->|push| L[Loki]

    TR -->|":8080 metrics"| P[Prometheus]
    NE[node-exporter] -->|":9100"| P
    P --> AM[Alertmanager]
    P -->|"query :9090"| G[Grafana]
    L -->|"query :3100"| G
    TR -.->|"ingress: monitoring.DOMAIN"| G
```
