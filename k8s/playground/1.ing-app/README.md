### setup minikube cluster
`$ minikube start --cpus=2 --memory=4gb --disk-size=25gb --vm-driver=virtualbox`
### enable nginx ingress
`$ minikube addons enable ingress`
## Deploy
### deploy app via kubectl
`$ kubectl apply -f k8s.yml`
### deploy app via terraform
```
$ terraform init
$ terraform plan
$ terraform apply  
```
### deploy via helm
`$ helm install fastapi helm/`
### check resource
```
$ minikube ip
192.168.99.118
-------------------------------------------------------------------------------------
$ curl http://192.168.99.118/
{"Hello":"World"}%
-------------------------------------------------------------------------------------
$ curl http://192.168.99.118/container
{"hostName":"fa-deploy-5955698659-mplvx","timeStamp":"1621524377.203715","uuid":"docker-26981000f42870e7c5542d0efda52b88e4638a1a2e60cf114205047ee18f7cc9.scope"}%
-------------------------------------------------------------------------------------
$ curl http://192.168.99.118/container
{"hostName":"fa-deploy-5955698659-6kzw9","timeStamp":"1621524379.3787112","uuid":"docker-1b9d784a5d732be934a8e6b02da16158a1f0fa9c48429cdf11afb70ab4f72c43.scope"}%
```
