# Overview

Deployment strategies:
- Recreate
- RollingUpdate
- Blue/Green
- Canary
- A/B (canary with the statement)

> NOTE: requirements: minikube, kubectl, make, jsonnet, httpie

Install minikube (if you want to communicate with app via local dns, you should configure it yourself, [doc](https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/)):

# blue/green

```shell
make minikube
```

Deploy application (green) and it's future version (blue)

```shell
❯ make bgd-init
jsonnet --ext-str color="green" template-cm-deploy.jsonnet | kubectl apply -f -
configmap/configmap-green unchanged
deployment.apps/myapp-green created
jsonnet --ext-str color="blue" template-cm-deploy.jsonnet | kubectl apply -f -
configmap/configmap-blue unchanged
deployment.apps/myapp-blue created
jsonnet --ext-str color="green" template-svc-ing.jsonnet | kubectl apply -f -
service/myapp-green created
service/myapp-green created
ingress.networking.k8s.io/myapp-green created
sleep 10
http GET "myapp"."dev"
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 12
Content-Type: text/plain
Date: Sun, 19 Dec 2021 11:44:20 GMT

I am green!
```

Promote blue to handle user traffic

```shell
❯ make bgd-promote
kubectl patch service "myapp"-green -p '{"spec":{"selector":{"deploy":"blue"}}}'
service/myapp-green patched
sleep 10
http GET "myapp"."dev"
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 11
Content-Type: text/plain
Date: Sun, 19 Dec 2021 11:45:12 GMT

I am blue!
```
clear cluster:
```shell
make teardown
```

ref: https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/

# a-b/canary

Create resources
```shell
❯ make canary-init 
jsonnet --ext-str color="stable" template-cm-deploy.jsonnet | kubectl apply -f -
configmap/configmap-stable unchanged
deployment.apps/myapp-stable created
jsonnet --ext-str color="stable" template-svc-ing.jsonnet | kubectl apply -f -
service/myapp-stable created
service/myapp-stable created
ingress.networking.k8s.io/myapp-stable created
jsonnet --ext-str color="canary" template-cm-deploy.jsonnet | kubectl apply -f -
configmap/configmap-canary unchanged
deployment.apps/myapp-canary created
jsonnet --ext-str color="canary" --tla-code canary=true template-svc-ing.jsonnet | kubectl apply -f -
service/myapp-canary created
service/myapp-canary created
ingress.networking.k8s.io/myapp-canary created
```
Check stable and release version:
```shell
❯ make canary-check                                   
http GET "myapp"."dev"
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 13
Content-Type: text/plain
Date: Sun, 19 Dec 2021 11:46:55 GMT

I am stable!


http GET "myapp"."dev" Cookie:tester=always
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 13
Content-Type: text/plain
Date: Sun, 19 Dec 2021 11:46:56 GMT

I am canary!
```
Clear resources:
```shell
make teardown
```
