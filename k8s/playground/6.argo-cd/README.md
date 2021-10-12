# 1.raw-yaml

## Устанавливаем Argo CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

## Доступ к UI

```bash
# Получаем пароль от UI
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 
# Делаем port-forwarding для UI
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
```

## Устанавливаем приложение green
```bash
 kubectl create -f app-green.yml
kubectl get po -n green
NAME                                  READY   STATUS    RESTARTS   AGE
nginx-deploy-green-7cf959f56c-tl2wj   1/1     Running   0          4m18s

kubectl exec -it nginx-deploy-green-7cf959f56c-tl2wj -- sh
---
curl 127.0.0.1
<h1>I am <font color=green>GREEN</font></h1>#
```
