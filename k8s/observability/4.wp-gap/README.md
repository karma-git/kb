# Overvew

Monitoring WordPress via GAP stack.

Goal: a lot of usefull information about application in grafana.

<details>
<summary>Reading List</summary>

- https://github.com/aorfanos/wordpress-exporter
- https://github.com/CodeAtCode/WPDB-Status
- https://daniele.tech/2019/11/monitor-wordpress-with-prometheus-and-grafana/
- https://github.com/prometheus

</details>

## Installation

```shell
make all
```

After it you should configure local dns-resolver accoring to [docmunetation](https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/)

## Endpoints:

> ! NOTE: if you configured local dns for *.dev domain and still reciving `502` - just wait a bit.

- http://word-press.dev/
- http://grafana.dev/
- http://alertmanager.dev/
- http://prometheus.dev/


## Grafana dashboards

Upload dashboards to grafana ui via import button, you should see something like:

<details>

## apache exporter
![web](https://i.imgur.com/uvDMGBH.png)
## mysql exporter
![db](https://i.imgur.com/pCQUicD.png)
## node exporter
![node](https://i.imgur.com/73LqCYJ.png)
## compute (pod)
![pod](https://i.imgur.com/YUloCUD.png)

</details>

> ! NOTE: now feel free to clean cluster via `make delete` or delete entire cluster via `minikube delete`
