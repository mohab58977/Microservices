terraform {
  required_version = ">= 1.8.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
   resource_group_name  = "pwc"
    storage_account_name = "00terraformpwc"
    container_name       = "tfstate"      # or whatever container you created
    key                  = "terraform.tfstate"
  
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

# Subnet for AKS
resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.aks_subnet_address_prefixes
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = "default"
    node_count          = var.default_node_count
    vm_size             = var.default_node_vm_size
    vnet_subnet_id      = azurerm_subnet.aks.id
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.enable_auto_scaling ? var.min_node_count : null
    max_count           = var.enable_auto_scaling ? var.max_node_count : null
    os_disk_size_gb     = 30
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = "standard"
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
  }

  tags = var.tags
}

# Additional Managed Node Pool (Small)
resource "azurerm_kubernetes_cluster_node_pool" "small" {
  name                  = "small"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_B2s"
  node_count            = 1
  vnet_subnet_id        = azurerm_subnet.aks.id
  enable_auto_scaling   = false
  os_disk_size_gb       = 30

  tags = var.tags
}
