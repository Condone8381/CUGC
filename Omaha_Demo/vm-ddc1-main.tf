resource "azurerm_network_interface" "terraform-ddc1-server-interface" {
  name                = "terraform-ddc1-server-interface"
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
resource "azurerm_windows_virtual_machine" "ddc1" {
  name                  = "ddc1"
  admin_username        = "azureuser"
  admin_password        = "CUGCDemo123!"
  location              = var.location
  resource_group_name   = azurerm_resource_group.terraform-resource-group.name
  network_interface_ids = [
    azurerm_network_interface.terraform-ddc1-server-interface.id,
  ]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "ddc1OsDisk"
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

# DDC1 virtual machine extension - Install DDC Prerequisites
resource "azurerm_virtual_machine_extension" "ddc1-vm-extension" {
  depends_on=[azurerm_windows_virtual_machine.ddc1]

  name                 = "ddc1-vm-active-directory"
  virtual_machine_id   = azurerm_windows_virtual_machine.ddc1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"  
  settings = <<SETTINGS
  {
    "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -Command Install-WindowsFeature NET-Framework-45-Core,GPMC,RSAT-ADDS-Tools,RDS-Licensing-UI,WAS,Telnet-Client"
  }
  SETTINGS

  tags = { 
    application = var.app_name
    environment = var.environment
  }
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "ddc01-shutdown" {
  virtual_machine_id          = azurerm_windows_virtual_machine.ddc1.id
  location                    = azurerm_resource_group.terraform-resource-group.location
  enabled                     = true
  daily_recurrence_time       = "1800"
  timezone                    = "Eastern Standard Time"
  notification_settings {
    enabled         = false
   
  }
}
