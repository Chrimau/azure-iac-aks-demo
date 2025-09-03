resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}-rg"
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name = "${var.prefix}-vet"
    location = azurerm_resource_group.rg.location
    azurerm_resource_group_name = azurerm_resource_group.rg.name
    address_space = ["10.42.0.0/16"]
}

resource "azurerm_subnet" "aks" {
    name = "aks-subnet"
    azurerm_resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.42.0.0/24"]
}

resource "azurerm_container_registry" "acr" {
    name = replace("${var.prefix}acr","-","")
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    sku = "Basic"
    admin_enabled = false
}

resource "azurerm_kubernetes_cluster" "aks" {
    name = "${var.prefix}-aks"
    loaction = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    dns_prefix = "${var.prefix}-dns"

    default_node_pool {
        name = "system"
        node_count = var.node_count
        vm_size = "Standard_DS2_v2"
        vnet_subnet_id = azurerm_subnet.aks.id
    }

    identity { type = "SystemAssigner" }
    netwrok_profile {
        network_plugin = "azure" # azure CNI
        load_balancer_sku = "standard"
}
role_based_access_control_enabled = true
    }

    # allow kubernets identity to pull from azurerm_container_registry
    resource "azurerm_role_assignment" "acrpull" {
        scope = azurerm_container_registry.acr.id
        role_definition_name = "AcrPull"
        principal_id = "azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
    }