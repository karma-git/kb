# Overview

Создание basic авторизации, в качестве middleware траефика при запросе к хосту.

https://doc.traefik.io/traefik/v2.0/middlewares/basicauth/

```bash
docker run -it ubuntu:latest
apt update && apt install -y apache2-utils && htpasswd -c /tmp/.htpasswd user1  # создаем пользователя
base64 /tmp/.htpasswd
```
Получишвуюся строку подставляем в манифест:
```bash
sed -i "s|__BASE64_SECRET__|<результат>|" traefic.yaml
```
