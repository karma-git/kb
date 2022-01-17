all: init install port-forwarding
init: minikube-create helm-init
install: mongo-install prometheus-install
port-forwarding: mogngo-port-forwarding gap-port-forwarding
clean: kill-all-pf delete

minikube-create:
	minikube start --cpus 4 --memory 8192 --vm-driver hyperkit

helm-init:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add stable https://charts.helm.sh/stable
	helm repo update

prometheus-install:
	helm upgrade --install prometheus prometheus-community/kube-prometheus-stack

gap-port-forwarding:
	@echo grafana, alert-manager, and prometheus services will be exposed via port-forwarding as a background tasks
	@echo grafana creds admin prom-operator

	kubectl port-forward service/prometheus-kube-prometheus-prometheus 9090 &
	kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093 &
	kubectl port-forward deployment/prometheus-grafana 3000 &

mongo-install:
	@echo installing mongo
	kubectl create -f mongodb.yml

	@echo installing mongo-exporter
	helm upgrade --install mongodb-exporter prometheus-community/prometheus-mongodb-exporter -f mongodb-exporter.values.yml

mogngo-port-forwarding:
	@echo grafana, alert-manager, and prometheus services will be exposed via port-forwarding as a background tasks

	kubectl port-forward svc/mongodb-service 27017 &
	kubectl port-forward service/mongodb-exporter-prometheus-mongodb-exporter 9216 &

kill-all-pf:
	@echo kill all background tasks
	sh stop-background-tasks.sh

delete:
	helm delete prometheus
	helm delete mongodb-exporter
	kubectl -n default delete all --all
