all: init install
init: minikube helm-init
install: prometheus-install wordpress-install mysql-exporter-install ingress

minikube:
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
	helm -n prometheus-stack upgrade --install prometheus prometheus-community/kube-prometheus-stack -f ./k8s/gap.values.yml

wordpress-install:
	# ref: https://github.com/bitnami/charts/blob/master/bitnami/wordpress/values.yaml
	helm -n word-press upgrade --install wp bitnami/wordpress -f ./k8s/wp.values.yml

mysql-exporter-install:
	helm -n prometheus-stack upgrade --install mysql-exporter prometheus-community/prometheus-mysql-exporter -f ./k8s/mysql-exporter.values.yml

ingress:
	kubectl apply -f ./k8s/minikube-ingress.yml

delete:
	helm -n prometheus-stack delete prometheus
	helm -n word-press delete wp
	helm -n prometheus-stack delete mysql-exporter
	kubectl delete -f ./k8s/minikube-ingress.yml
