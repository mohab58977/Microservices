### Simple terraform code is provided to deploy an aks cluster on azure
### Simple terraform pipeline is created to  authenticate and deploy Infra to my azure account using terraform
### Simple cicd pipeline is created to create the docker image push to github registry and deploy to my aks cluster on azure

### manual steps:
## create oidc on azure for github
## create a blob storage for terraform backend
## create monitoring stack via helm from azure cloudshell or we can enable managed prometheus and grafana form azure
# 1. Add the Prometheus Community Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# 2. Update local Helm chart list
helm repo update

# 3. Create a namespace (recommended)
kubectl create namespace monitoring

# 4. Install the kube-prometheus-stack chart
helm install monitoring-stack prometheus-community/kube-prometheus-stack --namespace monitoring


