# Обзор
Хотелось бы, чтобы ec2 инстансы могли пулить докер образы из ECR без авторизации.

Создаем роль разрешающую это и применяем инстанс профайл на ec2.

На виртуалке делаем:

```bash
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
```
