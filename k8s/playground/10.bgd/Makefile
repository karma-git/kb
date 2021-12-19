minikube:
	minikube start
	minikube addons enable ingress
	minikube addons enable ingress-dns
	sudo sed -e "s|192.168.64.[0-9]\{2,3\}|$(minikube ip)|" /etc/resolver/minikube-minikube-dev
bgd:
	jsonnet --ext-str color="green" template.jsonnet | kubectl apply -f -
	jsonnet --ext-str color="blue" template.jsonnet | kubectl apply -f -
	kubectl apply -f svc-int.yml
	sleep 10
	http GET myapp.dev
promote:
	kubectl patch service myapp -p '{"spec":{"selector":{"deploy":"blue"}}}'
	sleep 5
	http GET myapp.dev
