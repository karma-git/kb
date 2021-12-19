appName = "$(shell jsonnet utils.libsonnet | jq -r '.name')"
appDomain = "$(shell jsonnet utils.libsonnet | jq -r '.LocalDNS')"
appEndpoint := $(appName).$(appDomain)
appNamespace = "$(shell jsonnet utils.libsonnet | jq -r '.namespace')"
minikube:
	minikube start
	minikube addons enable ingress
	minikube addons enable ingress-dns
	sudo sed -e "s|192.168.64.[0-9]\{2,3\}|$(minikube ip)|" /etc/resolver/minikube-minikube-dev
bgd-init:
	jsonnet --ext-str color="green" template-cm-deploy.jsonnet | kubectl apply -f -
	jsonnet --ext-str color="blue" template-cm-deploy.jsonnet | kubectl apply -f -
	jsonnet --ext-str color="green" template-svc-ing.jsonnet | kubectl apply -f -
	sleep 10
	http GET $(appEndpoint)
bgd-promote:
	kubectl patch service $(appName)-green -p '{"spec":{"selector":{"deploy":"blue"}}}'
	sleep 10
	http GET $(appEndpoint)
canary-init:
	jsonnet --ext-str color="stable" template-cm-deploy.jsonnet | kubectl apply -f -
	jsonnet --ext-str color="stable" template-svc-ing.jsonnet | kubectl apply -f -
	jsonnet --ext-str color="canary" template-cm-deploy.jsonnet | kubectl apply -f -
	jsonnet --ext-str color="canary" --tla-code canary=true template-svc-ing.jsonnet | kubectl apply -f -
canary-check:
	http GET $(appEndpoint)
	http GET $(appEndpoint) Cookie:tester=always
teardown:
	kubectl -n $(appNamespace) delete all --all
	kubectl -n kube-system delete svc --selector app=$(appName)
	kubectl -n kube-system delete ing --selector app=$(appName)
