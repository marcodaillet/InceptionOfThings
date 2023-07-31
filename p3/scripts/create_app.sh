# Install Argo CD CLI (argocd) configuration
argocd login localhost:8080 --username admin --password password --insecure

# Create an Application in Argo CD
argocd app create mdaillet-app \
  --repo https://github.com/marcodaillet/IoTConfig-mdaillet.git \
  --path src \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --auto-prune \
  --self-heal \
  --sync-policy automated \
  --sync-option Prune=false

# Deploy the app
argocd app sync mdaillet-app
