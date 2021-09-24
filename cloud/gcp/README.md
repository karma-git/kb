# Overview

Взаимодействие с GCP может быть с помощью **[Cloud Console](https://console.cloud.google.com/)** или **[Cloud SDK](https://cloud.google.com/sdk)**.
### Cloud SDK
Cloud SDK это набор cli утилит для взаимодействия с ресурсами GCP:
- gcloud - управление ресурсами compute
- gsutil - управление сторэйджами
- bq - BigQuery

### Cloud Shell
[Cloud Shell](https://cloud.google.com/shell) - можно открыть веб-терминал через Cloud Console.

Это виртуалка выделенная под нас, PV для home директории, включает в себя **Cloud SDK**, kubectl и etc.

Сессия отваливается через час. Все что не в /home - stateless. Через 120 дней инактивности PV подчищают. Можно запросить виртуалку поплотнее на 24 часа через бурст. **tmux**.

Можно стартовать веб сервер и заходить на него через [web preview](https://cloud.google.com/shell/docs/using-web-preview).

## Project
[Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) - это некий аналог нескольких аккаунтов в aws, которые привязаны к одному биллингу.

Как удалить проект?:

Navigation menu -> IAM & Admin -> Settings -> Shutdown.

## VM

Navigation menu -> Compute Engine -> VM instances.

При первом использовании из-под проекта некоторое время инициализируется API.

Стандартно, выбирается:
- Name
- Region + Zone(AZ)
- Конфигруация VM: Series (Класс) и Machine type (Размер; p.s. наличие цифры в конце machine type говорит о количестве vCPU).
- ОС, бут диск.
- Firewall(SG) разрешающий http.

Можно еще конфигрурировать IAM и запустить на инстансе докер образ.

Можно посмотреть REST запрос или gcloud эквивалент:
```bash
gcloud beta compute --project=<project_name> instances create <instance_name> \
  --zone=europe-west3-c \
  --machine-type=f1-micro \ 
  --subnet=default ... \
  --tags=http-server \
  --image=centos-7-v20210916 ...
```

Подключиться можно через:
- веб-терминал Cloud Console (GCP генерирует ключи).
- с помощью gcloud cli в вашем терминале -> `gcloud beta compute ssh --zone <zone> <name>  --project "project id"`
-  прокинуть публичный ключ на вм-ке и зайти со своим ключом через public ip.
