# Overview

CKA topic: Cluster Architecture, Installation & Configuration

## single node k8s cluster

- CRI (containerd) [installation manual](https://github.com/containerd/containerd/blob/main/docs/cri/installation.md)
- [devopscube](https://raw.githubusercontent.com/scriptcamp/vagrant-kubeadm-kubernetes/main/scripts/common.sh)
- [just me and opensource](https://raw.githubusercontent.com/justmeandopensource/kubernetes/master/vagrant-provisioning/bootstrap.sh)

### history

1  cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

    2  apt-get update
    3  apt-get install -y kubelet kubeadm kubectl
    4  kubeadm
    5  VERSION=1.5.9
    6  wget https://github.com/containerd/containerd/releases/download/v${VERSION}/cri-containerd-cni-${VERSION}-linux-amd64.tar.gz
    7  # disable swap
    8  sudo swapoff -a
    9  # keeps the swaf off during reboot
   10  sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
   11  ifconfig
   12  ip a
   13  sudo swapoff -a
   14  # keeps the swaf off during reboot
   15  sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
   16  history
   17  ls
   18  sudo tar --no-overwrite-dir -C / -xzf cri-containerd-cni-${VERSION}-linux-amd64.tar.gz
   19  sudo systemctl daemon-reload
   20  sudo systemctl start containerd
   21  vim /etc/systemd/system/kubelet.service.d/0-containerd.conf
   22  systemctl daemon-reload
   23  kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.202
<!-- куб просит 2 cpu и ~1800 памяти -->
   24  kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.202 --ignore-preflight-errors=NumCPU,Mem,FileContent--proc-sys-net-bridge-bridge-nf-call-iptables,FileContent--proc-sys-net-ipv4-ip_forward
   25  crictl --runtime-endpoint /run/containerd/containerd.sock ps -a | grep kube | grep -v pause
   26  history
---

## master init

sudo kubeadm init --apiserver-advertise-address=192.168.1.81 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null
