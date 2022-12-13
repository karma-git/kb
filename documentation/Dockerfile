FROM alpine:3.17

RUN apk add --no-cache \
    python3=~3.10 \
    py3-pip=~22.3 \
  && pip install --no-cache-dir \
    mkdocs-material~=8.5 \
    mkdocs-awesome-pages-plugin~=2.8 \
    mkdocs-mermaid2-plugin~=0.6
    # mkdocs-blog-plugin~=0.25  # NOTE: insiders feature

RUN addgroup --gid 10001 app \
  && adduser \
    --uid 10001 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app

USER 10001

WORKDIR /home/app

ENTRYPOINT [ "" ]
