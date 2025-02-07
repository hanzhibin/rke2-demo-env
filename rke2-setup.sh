#!/usr/bin/bash


INSTALL_DIR=/mnt/rke2
RKE2='v1.28.13+rke2r1'
TOKEN=303fad0a-72a3-4515-ab3f-12b32793e4c3
TOKEN_FILE=/etc/rancher/rke2/cluster-secret.txt

## config.yaml parameters
RANCHER01_IP=10.241.59.66
RANCHER02_IP=10.241.59.67
RANCHER03_IP=10.241.59.68
RANCHER_FQDN=rancher.bsdd.local

## registries.yaml parameters
REGISTRY_URL=harbor.bsdd.local
CERT_DIR=/etc/rancher/rke2/certs


function create_rke2_config_file
{
cat << EOF > /etc/rancher/rke2/config.yaml
#server: https://${RANCHER_FQDN}:9345
token: "$TOKEN"
tls-san:
  - "${RANCHER_FQDN}"
  - "${RANCHER01_IP}"
  - "${RANCHER02_IP}"
  - "${RANCHER03_IP}"
EOF
}

function create_rke2_registries
{
cat << EOF > /etc/rancher/rke2/registries.yaml
mirrors:
  docker.io:
    endpoint:
      - "https://$REGISTRY_URL"
  harbor.bbac.local:
  ${REGISTRY_URL}:
    endpoint:
      - "https://$REGISTRY_URL"
configs:
  "$REGISTRY_URL":
    auth:
      username: admin
      password: Harbor12345
    tls:
      cert_file: "$CERT_DIR/tls.crt"
      key_file: "$CERT_DIR/tls.key"
      ca_file:  "$CERT_DIR/ca.crt"
EOF
}

#生成配置文件夹
mkdir -p /etc/rancher/rke2
echo $TOKEN > $TOKEN_FILE

#生成配置文件 "server" is used for agent to register

create_rke2_config_file

#生成registries.yaml文件
create_rke2_registries

#离线安装Rke2服务,指定离线文件位置
export INSTALL_RKE2_ARTIFACT_PATH="$INSTALL_DIR/$RKE2/"
sh scripts/install.sh

#启用rke2 server服务 ,需要等大约5分钟
systemctl enable --now rke2-server.service
sleep 1 

#查看服务状态
systemctl status rke2-server.service

#add kubectl env to .bashrc
sleep 2 
#source scripts/addenv.sh
#kubectl get node

echo "completed!.."
