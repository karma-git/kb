# Overview

Пример установки следующих компонентов `observability` в кластер k8s (в моем случае использовался minikube, подразумевается что он уже запущен):
- [Prometheus](https://prometheus.io/)-стэка
- [Кастомного экспортера](https://github.com/aws-exporters/ecr) для сборка метрик [AWS ECR](https://aws.amazon.com/ru/ecr/) и необходимых компонентов k8s для создания алерта
- [Кастомного receiver-a](https://github.com/metalmatze/alertmanager-bot) - получаем алерты в телеграм

Если вы не знакомы с архитектурой, предлагаю познакомиться:
- (Хабр)[https://habr.com/ru/company/southbridge/blog/569860/], перевод (статьи)[https://jonbc.medium.com/] ((github repo)[https://github.com/jonathanbc92/observability-quickstart]автора).
- (Хорошая презентация)[https://youtu.be/5Jr1v9mWnJc].

## Необходимые зависимости
- (helm)[https://helm.sh/] v3.6.3
- (kubectl)[https://kubernetes.io/docs/tasks/tools/] v1.21.3
- (yq)[https://github.com/mikefarah/yq/] 4.12.0

## Установка
Экспортируем переменные окружения.
```bash
export AWS_ACCESS_KEY_ID=id
export AWS_SECRET_ACCESS_KEY=key
export AWS_DEFAULT_REGION=region
export TELEGRAM_ADMIN=your_id
export TELEGRAM_TOKEN=telegram_bot_token
```
И запускаем скрипт, установка занимает около 3-5 мин.
```bash
sh _init.sh
```
После установки заходим в чат с ботом и пишем `/start`
