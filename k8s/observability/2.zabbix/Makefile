install-zabbix:
	minikube start --cpus=2 --memory=2gb --disk-size=20gb --vm-driver=hyperkit
	helm repo add cetic https://cetic.github.io/helm-charts
	helm repo update
	kubectl create ns monitoring
	helm -n monitoring upgrade --install zabbix cetic/zabbix --dependency-update
	@echo Waiting for zabbix, 80 sec ...
	sleep 80
	kubectl -n monitoring port-forward svc/zabbix-zabbix-web 8080:80
poetry:
	poetry install
py-zabbix:
	python3 zabbix/zabbix.py
