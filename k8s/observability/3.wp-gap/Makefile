all: minikube wp gap

provisioning: minikube kube-init

minikube:
	@echo "Minikube provisioning..........";\

	minikube start --cpus=2 --memory=2gb --disk-size=20gb --vm-driver=hyperkit
	minikube addons enable ingress
	minikube addons enable ingress-dns

	kubectl create ns word-press
	kubectl create ns prometheus-stack

	@echo minikube ip is - $(shell minikube ip)
	@echo read more how to setup minikube ingress-dns here https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/

kube-init:
	@echo add and update helm repos

	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

gap:
	helm -n prometheus-stack upgrade --install prometheus prometheus-community/kube-prometheus-stack

wp:
	# ref: https://github.com/bitnami/charts/blob/master/bitnami/wordpress/values.yaml
	helm -n word-press upgrade --install wp bitnami/wordpress -f wp.values.yml
