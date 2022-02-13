# Overview

CKA topic: Cluster Architecture, Installation & Configuration

## single node k8s cluster

- CRI (containerd) [installation manual](https://github.com/containerd/containerd/blob/main/docs/cri/installation.md)
- [devopscube](https://raw.githubusercontent.com/scriptcamp/vagrant-kubeadm-kubernetes/main/scripts/common.sh)
- [just me and opensource](https://raw.githubusercontent.com/justmeandopensource/kubernetes/master/vagrant-provisioning/bootstrap.sh)

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

# Roadmap

- [ ] - Ingress
- [ ] - Install GAP stack
- [ ] - Container Storage Interface
- [ ] - Install Code Server
