FROM python:3.10.0-alpine3.14

COPY ./requirements.txt ./requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

RUN addgroup --gid 10001 app \
  && adduser \
    --uid 10001 \
    --home /home/app \
    --shell /bin/ash \
    --ingroup app \
    --disabled-password \
    app

WORKDIR /home/app

USER app

COPY ./ /home/app

# default, can be overrided
ENV UVICORN_PORT 8000
EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/uvicorn"]
CMD ["main:app", "--reload", "--host=0.0.0.0",  "--no-access-log"]
