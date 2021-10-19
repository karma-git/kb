FROM alpine:3.14

RUN apk add --no-cache \
    bash~=5.1 \
    curl~=7.79 \
    docker-cli~=20.10 \
    git~=2.32 \
    nodejs~=14.18

RUN curl -O https://cli-assets.heroku.com/install.sh \
  && sh install.sh \
  && rm install.sh

RUN addgroup --gid 1950 docker \
  && addgroup --gid 10001 app \
  && adduser \
    --uid 10001 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app \
  && addgroup app docker

USER 10001
WORKDIR /home/app
