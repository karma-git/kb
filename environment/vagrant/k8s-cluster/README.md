# Overview

CKA topic: Cluster Architecture, Installation & Configuration

## single node k8s cluster

- CRI (containerd) [installation manual](https://github.com/containerd/containerd/blob/main/docs/cri/installation.md)
- `devopscube`: [article](https://devopscube.com/kubernetes-cluster-vagrant/), [github-repo](https://github.com/scriptcamp/vagrant-kubeadm-kubernetes)
- [just me and opensource](https://github.com/justmeandopensource/kubernetes/tree/master/vagrant-provisioning)

## master init

> Можно скипнуть различные требования `kubeadm`, например на 2 cpu и объем ram:
> 
> `kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.202 --ignore-preflight-errors=NumCPU,Mem,FileContent--proc-sys-net-bridge-bridge-nf-call-iptables,`

## node join

on master

```shell
kubeadm token create --print-join-command
```

Добавляем ноде роль.

```shell
kubectl label node node-2 node-role.kubernetes.io/worker=""
```

## node delete

Эвиктим с ноды все поды, и потом удаляем.
```shell
k drain node-3 --ignore-daemonsets
k delete node node-3
```
Возвращаем "сырой" воркер к стейту перед join-ом к кластеру:
```shell
kubeadm reset
```

# Roadmap

- [ ] - Metal LB
- [ ] - [DNS-server in private-network](https://ealebed.github.io/posts/2017/%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-dns-%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%D0%B0-%D0%B2-docker-%D0%BA%D0%BE%D0%BD%D1%82%D0%B5%D0%B9%D0%BD%D0%B5%D1%80%D0%B5/)
- [ ] - Ingress
- [ ] - Install GAP stack
- [ ] - Container Storage Interface
- [ ] - Install Code Server
