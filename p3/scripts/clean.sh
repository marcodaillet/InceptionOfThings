#!/bin/bash

# Delete namespaces
kubectl delete namespace argocd
kubectl delete namespace dev

# Uninstall Argo CD
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Delete K3D cluster
k3d cluster delete my-cluster

echo "Cleanup completed successfully."
