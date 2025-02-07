#!/usr/bin/bash


INTALL_DIR=/root/rke2
TOKEN=303fad0a-72a3-4515-ab3f-12b32793e4c3
TOKEN_FILE=/root/rke2/cluster-secret.txt
RANCHER01_IP=192.168.100.101
RANCHER02_IP=192.168.100.102
RANCHER03_IP=192.168.100.103
RANCHER_FQDN=rancher.example.com

#生成配置文件夹
mkdir -p /etc/rancher/rke2
echo $TOKEN > $TOKEN_FILE

#生成配置文件

cat << EOF > /etc/rancher/rke2/config.yaml
token-file: "$TOKEN_FILE"
tls-san:
  - "${RANCHER_FQDN}"
  - "${RANCHER01_IP}"
  - "${RANCHER02_IP}"
  - "${RANCHER03_IP}"
EOF

#离线安装Rke2服务,指定离线文件位置
#export INSTALL_RKE2_ARTIFACT_PATH=/var/lib/rancher/rke2/agent/images/
export INSTALL_RKE2_ARTIFACT_PATH="$INSTALL_DIR"
sh $INSTALL_DIR/install.sh

#启用rke2 server服务 ,需要等大约5分钟
systemctl enable --now rke2-server.service

#查看服务状态
systemctl status rke2-server.service
