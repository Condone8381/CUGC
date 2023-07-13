#################################
## Delivery Controllers - Main ##
#################################

# Create an availability set for delivery controllers
resource "azurerm_availability_set" "ddc-availability-set" {
  name                         = "ddc-availability-set-${var.environment}"
  resource_group_name          = azurerm_resource_group.terraform-resource-group.name
  location                     = azurerm_resource_group.terraform-resource-group.location
  platform_fault_domain_count  = 3
  platform_update_domain_count = 5
  managed                      = true
}