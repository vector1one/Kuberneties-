#!/bin/bash

curl https://releases.rancher.com/install-docker/20.10.sh | sh

echo -e '{\n  "exec-opts": ["native.cgroupdriver=cgroupfs"]\n}' | sudo tee /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker

curl -sfL https://get.k3s.io | sh -s server --docker
SERVER_NAME=$(hostname)  # or enter your local IP address
NODE_TOKEN=$(cat /var/lib/rancher/k3s/server/node-token)

curl -sfL https://get.k3s.io | K3S_URL=https://${SERVER_NAME}:6443 K3S_TOKEN=${NODE_TOKEN} sh -s agent --docker
