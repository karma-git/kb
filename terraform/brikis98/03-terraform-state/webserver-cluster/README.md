# Развертывание кластера веб-серверов
![schema](//terraform/brikis98/03-terraform-state/webserver-cluster/webservers.png)
## Создаем инфраструктуру
```
$ terraform init
$ terraform plan
$ terraform apply
```
## Проверяем работу балансировщика
```
...
Outputs:
alb_dns_name = "alb-instance-webserver-cluster-1089421545.eu-central-1.elb.amazonaws.com"
...
$ curl alb-instance-webserver-cluster-1089421545.eu-central-1.elb.amazonaws.com
Hello world from ip-172-31-4-82.eu-central-1.compute.internal
$ curl alb-instance-webserver-cluster-1089421545.eu-central-1.elb.amazonaws.com
Hello world from ip-172-31-16-97.eu-central-1.compute.internal
```