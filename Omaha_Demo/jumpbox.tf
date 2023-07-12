# Create public IPs
resource "azurerm_resource_group" "terraform-resource-group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_public_ip" "jumpbox_public_ip" {
  name                = "jumpbox-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
  allocation_method   = "Dynamic"
}

#Create the Security Group Association
resource "azurerm_subnet_network_security_group_association" "management-subnet-association" {
  subnet_id                 = azurerm_subnet.terraform-management-subnet.id
  network_security_group_id = azurerm_network_security_group.terraform-management-subnet-security-group.id
}
# Create network interface
resource "azurerm_public_ip" "terraform-jumpbox-management-public-ip" {
  name                = "jumpbox-management-public-ip"
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "terraform-jumpbox-management-interface" {
  name                = "terraform-jumpbox-management-interface"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  ip_configuration {
    name                          = "management"
    subnet_id                     = azurerm_subnet.terraform-management-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_public_ip.id
  }
  depends_on = [azurerm_subnet_network_security_group_association.management-subnet-association]
}

resource "azurerm_network_interface" "terraform-jumpbox-server-interface" {
  name                = "terraform-jumpbox-server-interface"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  ip_configuration {
    name                          = "server"
    subnet_id                     = azurerm_subnet.terraform-client-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_subnet_network_security_group_association.server-subnet-association]
}
# Connect the security group to the network interface
# resource "azurerm_subnet_network_security_group_association" "management-subnet-association" {
#   subnet_id                 = azurerm_subnet.terraform-management-subnet.id
#   network_security_group_id = azurerm_network_security_group.terraform-management-subnet-security-group.id
# }

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_jumpbox_storage_account" {
  name                     = "myjumpboxstorage"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.terraform-resource-group.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Create virtual machine
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "jumpbox"
  admin_username        = "azureuser"
  admin_password        = "CUGCDemo123!"
  location              = var.location
  resource_group_name   = azurerm_resource_group.terraform-resource-group.name
  network_interface_ids = [
    azurerm_network_interface.terraform-jumpbox-management-interface.id,
    azurerm_network_interface.terraform-jumpbox-server-interface.id,
  ]
  size                  = "Standard_DS2_v2"

  os_disk {
    name                 = "myOsDisk"
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

# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web_server_install" {
  name                       = "jumpbox-wsi"
  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
  SETTINGS
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "terraform_resource_group" {
  name                        = "jumpbox-shutdown"
  virtual_machine_id          = azurerm_windows_virtual_machine.main.id
  location                    = azurerm_resource_group.terraform_resource_group.location
  enabled                     = true
  daily_recurrence_time       = "1800"
  timezone                    = "Eastern Standard Time"
  notification_settings {
    enabled         = false
   
  }
}
