# Hermes

<https://hermes-agent.nousresearch.com/docs/>

## Setup

Run this before `docker compose up`

```bash
docker run -it --rm \
  -v ~/.hermes:/opt/data \
  nousresearch/hermes-agent setup
```

```bash
docker compose exec gateway hermes config set terminal.backend local
```