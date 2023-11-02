#ubuntu management network interface creation
resource "azurerm_network_interface" "terraform-ubuntu-web1-interface" {
  name                = "terraform-ubuntu-web1-interface"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  ip_configuration {
    name                          = "server"
    subnet_id                     = azurerm_subnet.terraform-server-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_subnet_network_security_group_association.server-subnet-association]
}

# ubuntu bastion host deployment
resource "azurerm_linux_virtual_machine" "terraform-ubuntu-web1-machine" {
  name                = "terraform-ubuntu-web1-machine"
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
  location            = var.location
  size                = var.ubuntu_vm_size
  admin_username      = var.ubuntu_admin_user
  network_interface_ids = [
    azurerm_network_interface.terraform-ubuntu-web1-interface.id
  ]
  admin_ssh_key {
    username   = var.ubuntu_admin_user
    public_key = file(var.ssh_public_key_file)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "web1" {
    virtual_machine_id = azurerm_linux_virtual_machine.terraform-ubuntu-web1-machine.id
    location           = azurerm_resource_group.terraform-resource-group.location
    enabled            = true

    daily_recurrence_time = "1730"
    timezone              = "Eastern Standard Time"

    notification_settings {
      enabled          = false
    }
}
