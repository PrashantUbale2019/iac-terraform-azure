output "resource_group_id" {
  value = azurerm_resource_group.iac-terraform-rg.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.iac-terraform-vnet.id
}