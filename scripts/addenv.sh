#!/usr/bin/bash

#增加path与命令补全,方便手工操作
echo 'export PATH=$PATH:$HOME/bin:/var/lib/rancher/rke2/bin' >> ~/.bashrc
echo 'export KUBECONFIG=/etc/rancher/rke2/rke2.yaml' >> ~/.bashrc
echo 'export CONTAINER_RUNTIME_ENDPOINT=unix:///run/k3s/containerd/containerd.sock' >> ~/.bashrc

source ~/.bashrc
