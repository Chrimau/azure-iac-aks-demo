# tell terraform to print the name of the resource group that was created after apply

output "rg" 
{
    value = azurerm_resource_group.rg.name
}

# tell terraform to print name of kluster created after apply

output "aks_name"
{ 
    value = azurerm_kubernetes_cluster.aks.name 
}