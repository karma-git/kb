FROM zabbix/zabbix-server-pgsql:ubuntu-5.4.5

USER 0

COPY ./zabbix /usr/lib/zabbix/alertscripts

RUN chown -R 1997:1997 /usr/lib/zabbix/alertscripts/

RUN apt update \
  && apt install -y python3 \
    python3-pip \
  && pip3 install --no-cache-dir \
    requests \
    pyyaml \
  && rm -rf /var/lib/apt/lists/*

USER 1997
