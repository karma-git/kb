# Overview
Создаем приложения argo (за их статусом можно следить в UI).
```bash
kubectl create -f .
Получаем имена подов.
```
bash
```bash
kubectl get pods -A --field-selector metadata.namespace!=kube-system,metadata.namespace!=argocd
NAMESPACE   NAME                           READY   STATUS    RESTARTS   AGE
blue        nginx-blue-bfdd5995-t4ktz      1/1     Running   0          19m
green       nginx-green-5f46575d6c-l78m7   1/1     Running   0          11m
```
Отправляем запрос к nginx-у.
```bash
kubectl exec nginx-blue-bfdd5995-t4ktz -n blue -- curl 127.0.0.1
<h1>I am <font color=blue>BLUE</font></h1>
kubectl exec nginx-green-5f46575d6c-l78m7 -n green -- curl 127.0.0.1
<h1>I am <font color=green>GREEN</font></h1>
```
