FROM alpine:3.14 as builder

RUN set -eux \
	&& apk add --no-cache \
		cargo~=1.52 \
		gcc~=10.3 \
		libffi-dev~=3.3 \
		musl-dev~=1.2 \
		openssl-dev~=1.1 \
		py3-pip~=20.3.4 \
		python3~=3.9.5 \
		python3-dev~=3.9.5 \
		rust~=1.52

ARG ANSIBLE_LINT_VERSION

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN set -eux \
  && pip3 install --no-cache-dir --no-compile "ansible-lint>=${ANSIBLE_LINT_VERSION}" \
  \
	&& pip3 install --no-cache-dir ansible==2.9.\* \
	\
	&& ansible-lint --version | head -1 | grep -E 'ansible-lint[[:space:]]+[0-9]+' \
	\
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

FROM alpine:3.14 as production

ARG ANSIBLE_LINT_VERSION

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN set -eux \
	&& apk add --no-cache \
		bash~=5.1 \
		git~=2.32 \
		python3~=3.9.5 \
	&& ln -sf ansible /usr/bin/ansible-config \
	&& ln -sf ansible /usr/bin/ansible-console \
	&& ln -sf ansible /usr/bin/ansible-doc \
	&& ln -sf ansible /usr/bin/ansible-galaxy \
	&& ln -sf ansible /usr/bin/ansible-inventory \
	&& ln -sf ansible /usr/bin/ansible-playbook \
	&& ln -sf ansible /usr/bin/ansible-pull \
	&& ln -sf ansible /usr/bin/ansible-test \
	&& ln -sf ansible /usr/bin/ansible-vault \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

COPY --from=builder /usr/lib/python3.9/site-packages/ /usr/lib/python3.9/site-packages/
COPY --from=builder /usr/bin/ansible-lint /usr/bin/ansible-lint
COPY --from=builder /usr/bin/ansible /usr/bin/ansible
COPY --from=builder /usr/bin/ansible-connection /usr/bin/ansible-connection

RUN set -eux \
	&& ansible-lint --version | head -1 | grep -E 'ansible-lint[[:space:]]+[0-9]+' \
	\
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

RUN addgroup --gid 1000 app \
  && adduser \
    --uid 1000 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app 

USER 1000

WORKDIR /home/app
ENTRYPOINT ["ansible-lint"]
CMD ["--version"]
