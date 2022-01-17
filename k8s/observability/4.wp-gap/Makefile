all: minikube wp gap
init: minikube-create helm-init
install: prometheus-install
port-forwarding: mogngo-port-forwarding
clean: kill-all-pf delete

minikube-create:
	@echo "Minikube provisioning..........";\

	minikube start --cpus 4 --memory 8192 --vm-driver hyperkit
	minikube addons enable ingress
	minikube addons enable ingress-dns

	kubectl create ns word-press
	kubectl create ns prometheus-stack

	@echo minikube ip is - $(shell minikube ip)
	@echo read more how to setup minikube ingress-dns here https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/

helm-init:
	@echo add and update helm repos

	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

prometheus-install:
	# ref: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
	helm -n prometheus-stack upgrade --install prometheus prometheus-community/kube-prometheus-stack -f gap.values.yml

wordpress-install:
	# ref: https://github.com/bitnami/charts/blob/master/bitnami/wordpress/values.yaml
	helm -n word-press upgrade --install wp bitnami/wordpress -f wp.values.yml

ingress-install:
	kubectl apply -f minikube-ingress.yml
