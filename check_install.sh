#!/bin/bash

set -e

echo "=== 檢查 go ==="
if command -v go &> /dev/null; then
    go version
else
    echo "[INFO] 未安裝 go，開始安裝..."
    sudo apt update
    sudo apt install -y golang-go
    go version
fi

echo "=== 檢查 kubectl ==="
if command -v kubectl &> /dev/null; then
    kubectl version --client --short
else
    echo "[INFO] 未安裝 kubectl，開始安裝..."
    curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    kubectl version --client --short
    rm kubectl
fi

echo "=== 檢查 docker ==="
if command -v docker &> /dev/null; then
    docker --version
else
    echo "[INFO] 未安裝 docker，開始安裝..."
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
    newgrp docker
    docker --version
fi

echo "=== 檢查 docker-compose ==="
if docker compose version &> /dev/null; then
    docker compose version
elif command -v docker-compose &> /dev/null; then
    docker-compose --version
else
    echo "[INFO] 未安裝 docker-compose（獨立版本），開始安裝..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
fi

echo "✅ 所有檢查與安裝完成！"

