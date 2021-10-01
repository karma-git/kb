FROM alpine:3.14

RUN apk add --no-cache \
    bash~=5.1 \
    curl~=7.79 \
    docker-cli~=20.10 \
    git~=2.32 \
    gzip~=1.10 \
    jq~=1.6 \
    make~=4.3 \
    tar~=1.34 \
    python3=~3.9.5 \
    py3-pip=~20.3.4 \
  && pip install --no-cache-dir \
    awscli~=1.20.35 \
    j2cli~=0.3.10

# Kubectl and Helm

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl \
  && kubectl version --client --short

WORKDIR /tmp
RUN curl -LO https://get.helm.sh/helm-v3.5.3-linux-amd64.tar.gz \
  && tar xzvf helm-*-linux-amd64.tar.gz \
  && rm -f helm-*-linux-amd64.tar.gz \
  && chmod +x linux-amd64/helm \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && rm -rf ./linux-amd64/ \
  && helm version --short

# yq

RUN curl -LO  https://github.com/mikefarah/yq/releases/download/v4.12.1/yq_linux_amd64.tar.gz \
  && tar xzvf yq_linux_amd64.tar.gz \
  && mv yq_linux_amd64 /usr/bin/yq \
  && rm -f yq_linux_amd64

RUN addgroup --gid 1950 docker \
  && addgroup --gid 1000 app \
  && adduser \
    --uid 1000 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app \
  && addgroup app docker

USER 1000
WORKDIR /home/app
