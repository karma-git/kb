# Обзор

Есть два амазон аккаунта **A** и **B**. 

В аккаунте A находится реджистри ECR.

Необходимо чтобы виртуалки из аккаунта B могли пулить образы.

## Шаги
- Выполняем терраформ код.
- Заходим на ec2 инстанс
- Обновляем apt кеш `sudo apt update`
- Устанавливаем ансибл `sudo apt install -y ansible`
- Копируем руками плейбук и выполняем его `ansible-playbook p.yml`
## Логин в ECR при помощи роли
Создаем директорию c конфигом `~/.aws/`

Добавляем в `~/.aws/config`:

```bash
[profile b]
role_arn = arn:aws:iam::<account_id>:role/role-a

credential_source = Ec2InstanceMetadata
```

Проверяем что все успешно:
```bash
aws sts get-caller-identity --profile b
{
    "UserId": "<session>",
    "Account": "<account_id>",
    "Arn": "arn:aws:sts::<account_id>-role/<session>"
}
```

Логинимся в ECR.

```bash
aws ecr get-login-password --region <region> --profile b | docker login --username AWS --password-stdin <account_id>.dkr.ecr.<region>.amazonaws.com
```

Теперь можно пулить образы.
