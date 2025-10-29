# Microservices on AKS

Flask microservices app running on Azure Kubernetes with automated CI/CD.

## What's Included

- **Flask API** with user/product endpoints
- **Terraform** for AKS infrastructure
- **CI/CD pipeline** - builds Docker images and deploys to AKS
- **Kubernetes manifests** with health checks and monitoring

## Quick Setup

### 1. Azure OIDC Authentication

Configure GitHub Actions to authenticate with Azure using OIDC (no secrets needed).

Add these to GitHub repo secrets:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID` 
- `AZURE_SUBSCRIPTION_ID`

### 2. Terraform Backend Storage

```bash
az group create --name pwc --location westeurope
az storage account create --name 00terraformpwc --resource-group pwc
az storage container create --name tfstate --account-name 00terraformpwc
```

### 3. Deploy Infrastructure

Run **Terraform Azure Pipeline** workflow:
- Action: `apply`
- Environment: `dev`

Creates: VNet, AKS cluster (`aks-microservices`), resource group (`rg-microservices`)

### 4. Deploy Application

Run **CI/CD Pipeline** workflow to build and deploy.

## Test the API

```bash
curl 9.163.20.202:80/
curl curl 9.163.20.202:80/users
```

## Endpoints

- `/health` - Health check
- `/` - API info
- `/users` - List users
- `/products` - List products

## Optional Monitoring

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install monitoring-stack prometheus-community/kube-prometheus-stack -n monitoring
```

Or enable Azure Monitor from the portal.

