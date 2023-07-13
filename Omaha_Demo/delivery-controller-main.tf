#################################
## Delivery Controllers - Main ##
#################################

# Locals
locals {
  dns_servers = [ var.ad_dc1_ip_address, var.ad_dc2_ip_address ]
  dc_servers = [ var.ad_dc1_ip_address, var.ad_dc2_ip_address ]
}

# Create an availability set for delivery controllers
resource "azurerm_availability_set" "ddc-availability-set" {
  name                         = "dc-availability-set-${var.environment}"
  resource_group_name          = azurerm_resource_group.terraform-resource-group.name
  location                     = azurerm_resource_group.terraform-resource-group.location
  platform_fault_domain_count  = 3
  platform_update_domain_count = 5
  managed                      = true
}