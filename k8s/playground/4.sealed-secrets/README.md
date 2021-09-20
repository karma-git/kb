# Sealed Secrets Overview
[GitHub](https://github.com/bitnami-labs/sealed-secrets)
[arthurkoziel blog](https://www.arthurkoziel.com/encrypting-k8s-secrets-with-sealed-secrets/)
## Install Sealed Secrets controller into k8s cluster via helm
```bash
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm install sealed-secrets --namespace kube-system sealed-secrets/sealed-secrets
```
## Install client side tool to encrypt secrets (create sealed-secrets).
```bash
# macos
brew install kubeseal

# linux
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.13.1/kubeseal-linux-amd64 -O kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```
## Create Sealed Secret
```bash
kubectl create secret generic secret-name --dry-run --from-literal=foo=bar -o yaml | \
 kubeseal \
 --controller-name=sealed-secrets \
 --controller-namespace=kube-system \
 --format yaml > mysealedsecret.yaml
 ```
 Let's apply `mysealedsecret.yaml` into cluster -> `kubectl create -f mysealedsecret.json` and you'll see that both secret and sealed-secret objects will be created.
 ```bash
 $ k get secrets,sealedsecrets
NAME                         TYPE                                  DATA   AGE
secret/default-token-jw6th   kubernetes.io/service-account-token   3      49m
secret/secret-name           Opaque                                1      12m

NAME                                   AGE
sealedsecret.bitnami.com/secret-name   12m
 ```
