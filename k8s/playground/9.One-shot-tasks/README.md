# Что это?

Деплоймент и _"One shot tasks"_ для [django-crud-with-postgres-and-docker-compose](https://gitlab.com/web352/django-rest/).

## How to? 
Клонируем второй репозиторий:
```bash
git clone https://gitlab.com/web352/django-rest/ \
  && cd django-rest 
```
Стартуем миникуб, собираем нужный образ в его реджистри
```bash
minikube start
minikube image build . -t crud:latest
```
Открываем репозиторий с манифестами, частично применяем их:
```bash
for resource in db.secret.yml db.yml app.yml;
  do 
    if test -f ${resource}; then
        kubectl create -f ${resource};
    else
       echo "Looks like you in wrong directory"
       exit 1
    fi
done
```
...