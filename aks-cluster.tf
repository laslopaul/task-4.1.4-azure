provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "task-414"
  location = "East US 2"
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "task-414-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "task-414-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  # Connect the cluster to Azure Monitor
  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
    }
  }

}
