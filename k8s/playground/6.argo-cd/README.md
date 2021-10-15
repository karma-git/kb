# Overview
TODO
# Установка Argo CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

# Доступ к UI

```bash
# Получаем пароль от UI
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d 
# Делаем port-forwarding для UI
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
```

# CLI
TODO