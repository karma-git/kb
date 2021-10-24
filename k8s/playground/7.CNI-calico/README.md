# Overview
Самостоятельное задание

Создайте сетевую политику, в которой разрешите доступ всем pod'ам из namespace `dev` только к pod'у `test` в namespace `base`, ко всем остальным pod'ам в namespace `base` доступ должен быть закрыт.

Проверочное задание:

Из pod'ов access и `test` в namespace `dev` должен проходить ping только pod `test` в namespace `base`.

ping'и на pod'ы access и `base` не должны проходить.

После выполнения практики удалите namespace `dev`, `prod`, `base`.

---

Установка minikube с CNI плагином calico (занимает около ~8 мин):
```bash
minikube start --cpus=2 --memory=4gb --disk-size=25gb --vm-driver=hyperkit --network-plugin=cni --cni=calico
kubectx minikube
watch kubectl get pods -l k8s-app=calico-node -A
```
Создаем поды и неймспейсы для эксперимента:
```bash
./prepare.sh
```
Смотрим адреса подов:
```bash
kubectl get pods -o wide -A --field-selector metadata.namespace!=kube-system                                                             
NAMESPACE   NAME     READY   STATUS    RESTARTS   AGE   IP              NODE       NOMINATED NODE   READINESS GATES
base        access   1/1     Running   0          21m   10.244.120.67   minikube   <none>           <none>
base        base     1/1     Running   0          21m   10.244.120.65   minikube   <none>           <none>
base        test     1/1     Running   0          21m   10.244.120.66   minikube   <none>           <none>
dev         access   1/1     Running   0          21m   10.244.120.71   minikube   <none>           <none>
dev         test     1/1     Running   0          21m   10.244.120.70   minikube   <none>           <none>
prod        access   1/1     Running   0          21m   10.244.120.68   minikube   <none>           <none>
prod        test     1/1     Running   0          21m   10.244.120.69   minikube   <none>           <none>
```
Ставим дополнительный лейбл на неймспейс dev и создаем "SG":
```bash
kubectl label ns dev type=dev
kubectl create -f hw.yml
kubectl get networkpolicies -n dev
```
Проваливаемся в поды нейспейса dev:
```bash
kubectl -n dev exec -it test -- sh
kubectl -n dev exec -it access -- sh
# ---
# Пингуем pod test -> OK
$ ping 10.244.120.66
PING 10.244.120.66 (10.244.120.66): 56 data bytes
64 bytes from 10.244.120.66: seq=0 ttl=63 time=0.728 ms
64 bytes from 10.244.120.66: seq=1 ttl=63 time=0.127 ms
^C
--- 10.244.120.66 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.127/0.427/0.728 ms
# Пингуем base
$ ping 10.244.120.65
PING 10.244.120.65 (10.244.120.65): 56 data bytes
^C
--- 10.244.120.65 ping statistics ---
2 packets transmitted, 0 packets received, 100% packet loss
# Пингуем access
$ ping 10.244.120.67
PING 10.244.120.67 (10.244.120.67): 56 data bytes
^C
--- 10.244.120.67 ping statistics ---
3 packets transmitted, 0 packets received, 100% packet loss
```
