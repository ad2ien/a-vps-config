# Superset

Instance of Superset to explorer data : <https://superset.apache.org/>

## Superset Image

If you need internationalization you'll need to make yourself a configured image of superset.

Edit `config.py` and set

- `LANGUAGES`
- `EXTRA_CATEGORICAL_COLOR_SCHEMES`
- ...

### Dockerfile

```Dockerfile
ARG BUILD_TRANSLATIONS="true"
...

# This was also needed in lean image
RUN --mount=type=cache,target=${SUPERSET_HOME}/.cache/uv \
    uv pip install psycopg2-binary
```

## Configure

Don't forget to change admin /admin credentials.
