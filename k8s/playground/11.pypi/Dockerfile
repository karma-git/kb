ARG PYPI_SERVER_VERSION=1.4.2

# ref: https://github.com/pypiserver/pypiserver/blob/master/Dockerfile
FROM pypiserver/pypiserver:v${PYPI_SERVER_VERSION}

RUN addgroup --gid 10001 app \
  && adduser \
    --uid 10001 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app

RUN chown 10001:10001 /data 

USER 10001
