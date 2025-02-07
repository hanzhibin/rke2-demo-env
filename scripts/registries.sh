#!/bin/bash
REGISTRY_URL=harbor.bbac.local
CERT_DIR=/mnt/harbor

cat << EOF > /etc/rancher/rke2/registries.yaml
mirrors:
  docker.io:
    endpoint:
      - "https://$REGISTRY_URL"
  harbor.bbac.local:
    endpoint:
      - "https://$REGISTRY_URL"
configs:
  "$REGISTRY_URL":
    auth:
      username: admin
      password: Harbor12345
    tls:
      cert_file: "$CERT_DIR/server-certs/tls.crt"
      key_file: "$CERT_DIR/server-certs/tls.key"
      ca_file:  "$CERT_DIR/server-certs/ca.crt" 
EOF
