# Overview

Simple blue / green deployment implementation:

> NOTE: requirements: minikube, kubectl, make, jsonnet, httpie

Install minikube (if you want to communicate with app via local dns, you should configure it yourself, [doc](https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/)):

```shell
make minikube
```

Deploy application (green) and it's future version (blue)

```shell
make bgd                                            
jsonnet --ext-str color="green" template.jsonnet | kubectl apply -f -
configmap/configmap-green unchanged
deployment.apps/myapp-green created
jsonnet --ext-str color="blue" template.jsonnet | kubectl apply -f -
configmap/configmap-blue unchanged
deployment.apps/myapp-blue created
kubectl apply -f svc-int.yml
service/myapp created
service/myapp unchanged
ingress.networking.k8s.io/myapp unchanged
sleep 10
http GET myapp.dev
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 12
Content-Type: text/plain
Date: Sun, 19 Dec 2021 07:45:08 GMT

I am green!
```

Promote blue to handle user traffic

```shell
make promote
kubectl patch service myapp -p '{"spec":{"selector":{"deploy":"blue"}}}'
service/myapp patched
sleep 5
http GET myapp.dev
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 11
Content-Type: text/plain
Date: Sun, 19 Dec 2021 07:45:20 GMT

I am blue!
```
