FROM zabbix/zabbix-server-pgsql:ubuntu-5.4.5

USER 0

RUN apt update \
  && apt install -y python3 \
    python3-pip \
  && pip3 install --no-cacher-dir \
    requests \
  && rm -rf /var/lib/apt/lists/*

USER 1997
`