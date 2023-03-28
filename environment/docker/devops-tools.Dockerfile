FROM alpine:3.13.12 as builder

# utils
ARG VERSION_KUBECTL=1.22.0
ARG VERSION_HELM=3.5.3
ARG VERSION_KUBESEAL=0.17.5
ARG VERSION_VM=1.88.1
# text processors
ARG VERSION_YQ=4.25.1
ARG VERTSION_HCL2JSON=0.3.4
ARG VERTSION_DASEL=2.0.2
ARG VERSION_STARSHIP=1.12.0

# TODO: goto basic image
RUN apk add --no-cache \
  curl~=7.79 \
  tar~=1.34

# kubectl

RUN curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${VERSION_KUBECTL}/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl \
  && kubectl version --client --short

# helm
RUN curl -sLO https://get.helm.sh/helm-v${VERSION_HELM}-linux-amd64.tar.gz \
  && tar xzvf helm-*-linux-amd64.tar.gz \
  && chmod +x linux-amd64/helm \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && helm version --short

# kubeseal
RUN curl -sLO https://github.com/bitnami-labs/sealed-secrets/releases/download/v${VERSION_KUBESEAL}/kubeseal-${VERSION_KUBESEAL}-linux-amd64.tar.gz \
  && tar xzvf "kubeseal-${VERSION_KUBESEAL}-linux-amd64.tar.gz" \
  && chmod +x kubeseal \
  && mv kubeseal /usr/local/bin/kubeseal \
  && kubeseal --version

# vmutils
RUN curl -sLO https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v${VERSION_VM}/vmutils-linux-386-v${VERSION_VM}.tar.gz \
  && tar xzvf "vmutils-linux-386-v${VERSION_VM}.tar.gz" \
  && mv vmctl-prod /usr/local/bin/vmctl \
  && mv vmagent-prod /usr/local/bin/vmagent \
  && mv vmauth-prod /usr/local/bin/vmauth \
  && mv vmbackup-prod /usr/local/bin/vmbackup \
  && mv vmrestore-prod /usr/local/bin/vmrestore

# yq
RUN curl -sLO  https://github.com/mikefarah/yq/releases/download/v${VERSION_YQ}/yq_linux_amd64.tar.gz \
  && tar xzvf yq_linux_amd64.tar.gz \
  && mv yq_linux_amd64 /usr/local/bin/yq \
  && yq --version

# hcl2json util
RUN curl -sLO  https://github.com/tmccombs/hcl2json/releases/download/v${VERTSION_HCL2JSON}/hcl2json_linux_amd64 \
  && chmod +x hcl2json_linux_amd64 \
  && mv hcl2json_linux_amd64 /usr/local/bin/hcl2json

# dasel
RUN curl -sLO "https://github.com/TomWright/dasel/releases/download/v${VERTSION_DASEL}/dasel_linux_amd64" \
    && chmod +x dasel_linux_amd64 \
    && mv dasel_linux_amd64 /usr/local/bin/dasel \
    && dasel --version

# starship
RUN curl -sLO https://github.com/starship/starship/releases/download/v${VERSION_STARSHIP}/starship-x86_64-unknown-linux-musl.tar.gz \
  && tar xzvf starship-x86_64-unknown-linux-musl.tar.gz \
  && mv starship /usr/local/bin/starship \
  && starship --version

# FINAL

FROM alpine:3.13.12 as final

ARG VERSION_ARGOCD=2.0.4

# Basic software

RUN apk add --no-cache \
  apache2-utils~=2.4 \
  bash~=5.1 \
  bind-tools~=9.16 \
  curl~=7.79 \
  docker-cli~=20.10 \
  fio~=3.25 \
  gettext~=0.20 \
  git~=2.30 \
  gzip~=1.12 \
  jq~=1.6 \
  make~=4.3 \
  moreutils~=0.65 \
  nmap~=7.91 \
  openssh-client~=8.4 \
  rsync~=3.2.5 \
  tar~=1.34 \
  coreutils~=8.32 \
  tcpdump~=4.99 \
  zsh~=5.8 \
  vim~=8.2


COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/local/bin/kubeseal /usr/local/bin/kubeseal
# vm
COPY --from=builder /usr/local/bin/vmctl /usr/local/bin/vmctl
COPY --from=builder /usr/local/bin/vmagent /usr/local/bin/vmagent
COPY --from=builder /usr/local/bin/vmauth /usr/local/bin/vmauth
COPY --from=builder /usr/local/bin/vmbackup /usr/local/bin/vmbackup
COPY --from=builder /usr/local/bin/vmrestore /usr/local/bin/vmrestore
# text processors
COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/hcl2json /usr/local/bin/hcl2json
COPY --from=builder /usr/local/bin/dasel /usr/local/bin/dasel
COPY --from=builder /usr/local/bin/starship /usr/local/bin/starship


# AWS CLI and some other tools

RUN apk add --no-cache \
  py3-pip~=20.3 \
  && pip install --no-cache-dir \
  awscli~=1.19.39 \
  j2cli[yaml]==0.3.10

# oh-my-zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# starship
RUN echo 'eval "$(starship init zsh)"' >> /root/.zshrc

# Argo CD
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v${VERSION_ARGOCD}/argocd-linux-amd64 \
  && chmod +x /usr/local/bin/argocd

# starship config
ADD https://raw.githubusercontent.com/karma-git/infra/master/dotfiles/starship.toml /root/.config/starship.toml

RUN \
    dasel put -f /root/.config/starship.toml -r toml -t bool -v false ".hostname.ssh_only" \
    && dasel put -f /root/.config/starship.toml -r toml -v "🐳(bold blue) on [\$hostname](bold red)" ".hostname.format"

# TODO: expose some web-server eg nginx, or better envoy
