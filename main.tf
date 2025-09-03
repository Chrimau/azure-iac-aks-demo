resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}-rg"
    location = var.location
}

resource = "azurerm_virtual_network" "vnet" {
    name = "${var.prefix}-vet"
    location = azurerm_resource_group.rg.location
}