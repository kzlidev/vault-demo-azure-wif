# Define a resource group
resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-resource-group"
  location = var.region
}
