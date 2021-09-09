FROM alpine:3.14

ARG TRIVY_VERSION=0.19.2
ARG TRIVY_URL=https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN addgroup --gid 1000 app \
  && adduser \
    --uid 1000 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app 

WORKDIR /tmp

RUN wget -O- -nv "${TRIVY_URL}"| tar -zxvf - \
  && mv trivy /bin \
  && mv contrib /home/app/contrib \
  && rm -rf /tmp/*

USER 1000
WORKDIR /home/app

ENTRYPOINT [ "trivy" ]
CMD ["--version"]
