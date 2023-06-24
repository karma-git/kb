# NOTE: minio for rpi4
FROM golang:latest as builder

RUN git clone https://github.com/minio/minio.git

WORKDIR /go/minio

ENV GOOS=linux
ENV GOARCH=arm

RUN go build

# FROM scratch
FROM alpine:3.18.2

COPY --from=builder --chmod=755 /go/minio/minio /usr/bin/minio

RUN addgroup --gid 1001 app \
  && adduser \
    --uid 1001 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app

USER 1001

# # api
EXPOSE 9000
# console
EXPOSE 36537

ENTRYPOINT [ "minio" ]
