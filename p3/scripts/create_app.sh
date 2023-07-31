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

# Port forwarding to access the application locally
kubectl port-forward svc/my-app -n dev 8888:80 &
port_forward_pid=$!

# Wait for a brief moment to allow port forwarding to be established
sleep 5

# Display a message indicating successful setup
echo "The application is now accessible via http://localhost:8888/"

# Keep the port forwarding command running in the background
wait $port_forward_pid
