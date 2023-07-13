# Create network interface
resource "azurerm_network_interface" "terraform-sf1-server-interface" {
  name                = "terraform-sf1-server-interface"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  ip_configuration {
    name                          = "server"
    subnet_id                     = azurerm_subnet.terraform-server-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_subnet_network_security_group_association.server-subnet-association]
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "sf1" {
  name                  = "sf1"
  admin_username        = "azureuser"
  admin_password        = "CUGCDemo123!"
  location              = var.location
  resource_group_name   = azurerm_resource_group.terraform-resource-group.name
  network_interface_ids = [
    azurerm_network_interface.terraform-sf1-server-interface.id,
  ]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "sf1OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }


  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_jumpbox_storage_account.primary_blob_endpoint
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "ddc01-shutdown" {
  virtual_machine_id          = azurerm_windows_virtual_machine.sf1.id
  location                    = azurerm_resource_group.terraform-resource-group.location
  enabled                     = true
  daily_recurrence_time       = "1800"
  timezone                    = "Eastern Standard Time"
  notification_settings {
    enabled         = false
   
  }
}
