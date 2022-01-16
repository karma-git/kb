all: minikube wp gap
minikube:
	minikube start --cpus=2 --memory=2gb --disk-size=20gb --vm-driver=hyperkit
wp:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update
	kubectl create ns word-press
	helm -n word-press upgrade --install wp bitnami/wordpress
	kubectl -n word-press get secret wp-wordpress -o jsonpath="{.data.wordpress-password}" | base64 --decode
gap:
	kubectl create ns prometheus-stack
	helm -n prometheus-stack upgrade --install prometheus prometheus-community/kube-prometheus-stack
