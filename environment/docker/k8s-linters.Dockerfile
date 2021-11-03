FROM golang:1.17.2-alpine3.14 AS build

RUN apk add git \
  && git clone https://github.com/zegl/kube-score \
  && cd kube-score \
  && go build github.com/zegl/kube-score/cmd/kube-score/ \
  && cd ..

RUN wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz \
  && tar xf kubeval-linux-amd64.tar.gz

FROM alpine:3.14 AS final

COPY --from=build /go/kube-score/kube-score /usr/bin/kube-score
COPY --from=build /go/kubeval /usr/bin/kubeval

RUN chmod 755 -R /usr/bin/

RUN addgroup --gid 10001 app \
  && adduser \
    --uid 10001 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app

USER 10001

ENTRYPOINT [ "" ]
