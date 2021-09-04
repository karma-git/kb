### setup minikube cluster
`$ minikube start --cpus=2 --memory=4gb --disk-size=25gb --vm-driver=virtualbox`
### enable nginx ingress
`$ minikube addons enable ingress`
## Deploy
### deploy app via kubectl
`$ kubectl apply -f manifest.yml`
### check resources
```
$ cip=`minikube ip`; fa="http://${cip}/fa/container"; fla="http://${cip}/flaskapi/ready"; curl $fa; echo; curl $fla;
{"hostName":"fa-deploy-5955698659-5ln6h","timeStamp":"1622606719.2247534","uuid":"docker-942c7fb028e571d9d93312a83397a1ae88d8c5a8efea789032479c492e4f5254.scope"}
{"hostName":"flaskapi-deploy-74fcbc8884-96jx2","timeStamp":"1622606719.243383","uuid":"docker-d1554dfe2d2fac65eab0d5ac3414112917715a29a05fc894e4d86739341f5602.scope"}
```
