FROM python:3.10.0-alpine3.14

RUN apk add curl jq \
  && pip install --no-cache-dir httpie

RUN addgroup --gid 10001 app \
  && adduser \
    --uid 10001 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app

USER app

WORKDIR /home/app

ENTRYPOINT [ "http" ]
CMD [ "" ]
