# Overview

У нас имеется кластер k8s из нескольких нод, в котором запущены различные приложения.

Нам необходимо спецальная нода X, для того чтобы запускать на ней особенное приложение Y.

Обычные приложения не должны шедулиться на ноду X.

Приложение Y не должно шедулиться ни на какие ноды, кроме ноды X.

# Step by step HOW TO
Go to https://labs.play-with-k8s.com/

Initializes cluster master node:
```bash
kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16
```

In output you'll see a comamnd with which other nodes could join cluster:
```bash
kubeadm join <kube_api> --token <token> \
    --discovery-token-ca-cert-hash <sha265:>
```

Initialize cluster networking on master node:
``bash
kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
```

Create 3 worker nodes and join to cluster.

Create taint for our special node:
```bash
kubectl taint nodes node4 special=gpu:NoSchedule
```
