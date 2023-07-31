#!/bin/bash

# Install Docker (if not already installed)
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    newgrp docker
fi

# Install kubectl (if not already installed)
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
fi

# Install K3D (if not already installed)
if ! command -v k3d &> /dev/null; then
    echo "Installing K3D..."
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v5.5.1 bash
fi

# Install Argo CD CLI (argocd)
if ! command -v argocd &> /dev/null; then
    echo "Installing Argo CD CLI (argocd)..."
    ARGOCD_VERSION="v2.1.2"
    curl -LO "https://github.com/argoproj/argo-cd/releases/download/$ARGOCD_VERSION/argocd-linux-amd64"
    chmod +x argocd-linux-amd64
    sudo mv argocd-linux-amd64 /usr/local/bin/argocd
fi

# create k3d cluster
k3d cluster create my-cluster --api-port 6443 -p 8888:80@loadbalancer -p 30001:30001@agent:0 -p 30002:30002@agent:0 --agents 1

# Set KUBECONFIG environment variable
export KUBECONFIG=$(k3d kubeconfig write my-cluster)

# Create namespaces
kubectl create namespace argocd
kubectl create namespace dev

# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/baremetal/deploy.yaml

# Wait for Argo CD pods to be ready
kubectl wait --for=condition=Ready pod -n argocd -l app.kubernetes.io/name=argocd-server --timeout=300s

# Set Argo CD password to "password"
kubectl -n argocd patch secret argocd-secret \
    -p '{"stringData": {
      "admin.password": "$2a$10$rRyBsGSHK6.uc8fntPwVIuLVHgsAhAX7TcdrqW/RADU0uh7CaChLa",
      "admin.passwordMtime": "'$(date +%FT%T%Z)'"
    }}'

# Print Argo CD server URL
echo "Argo CD server URL: http://localhost:8080"

# Port forwarding to access Argo CD UI (running in the background)
kubectl port-forward svc/argocd-server -n argocd 8080:80 >/dev/null 2>&1 &

# Store the port forwarding process ID
port_forward_pid=$!

# Wait for a brief moment to allow port forwarding to be established
sleep 5

# # Port forwarding to access Argo CD UI
# kubectl port-forward svc/argocd-server -n argocd 8080:80 &
# port_forward_pid=$!

# # Wait for port forwarding to be established
# sleep 5

# # Check if port forwarding process is still running
# if ps -p $port_forward_pid > /dev/null; then
#     echo "Port forwarding is active. Press Ctrl+C to stop."
#     wait $port_forward_pid
# else
#     echo "Port forwarding process has exited."
# fi

# echo "Initial setup completed successfully."
