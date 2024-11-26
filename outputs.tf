output "vm_public_ip" {
  value = azurerm_public_ip.controller.ip_address
}

output "vm_private_ip" {
  value = azurerm_network_interface.controller_public.private_ip_address
}

output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private.id
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}