# Azure Resource Group
resource "azurerm_resource_group" "terraform-resource-group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_availability_set" "terraform-availability-set" {
  name                = "terraform-availability-set"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  platform_update_domain_count = 2
  platform_fault_domain_count  = 2

}

resource "azurerm_virtual_network" "terraform-virtual-network" {
  name                = "terraform-virtual-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
  address_space       = [var.virtual_network_address_space]
}

resource "azurerm_subnet" "terraform-management-subnet" {
  name                 = "terraform-management-subnet"
  resource_group_name  = azurerm_resource_group.terraform-resource-group.name
  virtual_network_name = azurerm_virtual_network.terraform-virtual-network.name
  address_prefixes     = [var.management_subnet_address_prefix]
}

resource "azurerm_subnet" "terraform-server-subnet" {
  name                 = "terraform-server-subnet"
  resource_group_name  = azurerm_resource_group.terraform-resource-group.name
  virtual_network_name = azurerm_virtual_network.terraform-virtual-network.name
  address_prefixes     = [var.server_subnet_address_prefix]
}

resource "azurerm_subnet" "terraform-client-subnet" {
  name                 = "terraform-client-subnet"
  resource_group_name  = azurerm_resource_group.terraform-resource-group.name
  virtual_network_name = azurerm_virtual_network.terraform-virtual-network.name
  address_prefixes     = [var.client_subnet_address_prefix]
}

resource "azurerm_subnet_network_security_group_association" "management-subnet-association" {
  subnet_id                 = azurerm_subnet.terraform-management-subnet.id
  network_security_group_id = azurerm_network_security_group.terraform-management-subnet-security-group.id
}


resource "azurerm_network_security_group" "terraform-management-subnet-security-group" {
  name                = "terraform-management-subnet-security-group"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
}

// Allow ssh, http and https from controlling subnet
resource "azurerm_network_security_rule" "terraform-allow-all-from-controlling-subnet" {
  name                        = "terraform-allow-all-from-controlling-subnet"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "80", "443"]
  source_address_prefix       = var.controlling_subnet
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  network_security_group_name = azurerm_network_security_group.terraform-management-subnet-security-group.name
}

resource "azurerm_subnet_network_security_group_association" "client-subnet-association" {
  subnet_id                 = azurerm_subnet.terraform-client-subnet.id
  network_security_group_id = azurerm_network_security_group.terraform-client-subnet-security-group.id
}

resource "azurerm_network_security_group" "terraform-client-subnet-security-group" {
  name                = "terraform-client-subnet-security-group"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
}

// Allow http and https from everywhere
resource "azurerm_network_security_rule" "terraform-allow-client-http-from-internet" {
  name                        = "terraform-allow-client-http-from-internet"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  network_security_group_name = azurerm_network_security_group.terraform-client-subnet-security-group.name
}

resource "azurerm_subnet_network_security_group_association" "server-subnet-association" {
  subnet_id                 = azurerm_subnet.terraform-server-subnet.id
  network_security_group_id = azurerm_network_security_group.terraform-server-subnet-security-group.id
}

resource "azurerm_network_security_group" "terraform-server-subnet-security-group" {
  name                = "terraform-server-subnet-security-group"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
}

// Next two rules: Allow server subnet to reply only inside its own subnet
resource "azurerm_network_security_rule" "terraform-server-allow-outbound" {
  name                   = "terraform-server-allow-subnet-outbound"
  priority               = 1000
  direction              = "Outbound"
  access                 = "Allow"
  protocol               = "*"
  source_port_range      = "*"
  destination_port_range = "*"
  source_address_prefix  = "*"
  destination_address_prefixes = [
    azurerm_subnet.terraform-server-subnet.address_prefixes[0],
  ]
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  network_security_group_name = azurerm_network_security_group.terraform-server-subnet-security-group.name
}

resource "azurerm_network_security_rule" "terraform-server-deny-all-outbound" {
  name                        = "terraform-server-deny-all-outbound"
  priority                    = 1010
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  network_security_group_name = azurerm_network_security_group.terraform-server-subnet-security-group.name
}
 resource "azurerm_public_ip" "terraform-adc-management-public-ip" {
  name                = format("terraform-adc-management-public-ip-node-%v", count.index)
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
  location            = var.location
  allocation_method   = "Static"

  count = 2
}

resource "azurerm_network_interface" "terraform-adc-management-interface" {
  name                = format("terraform-adc-management-interface-node-%v", count.index)
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  ip_configuration {
    name                          = "management"
    subnet_id                     = azurerm_subnet.terraform-management-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.terraform-adc-management-public-ip.*.id, count.index)
  }
  depends_on = [azurerm_subnet_network_security_group_association.management-subnet-association]

  count = 2
}

resource "azurerm_network_interface" "terraform-adc-client-interface" {
  name                = format("terraform-adc-client-interface-node-%v", count.index)
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  ip_configuration {
    name                          = "client"
    subnet_id                     = azurerm_subnet.terraform-client-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_subnet_network_security_group_association.client-subnet-association]

  count = 2
}

resource "azurerm_network_interface" "terraform-adc-server-interface" {
  name                = format("terraform-adc-server-interface-node-%v", count.index)
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  ip_configuration {
    name                          = "server"
    subnet_id                     = azurerm_subnet.terraform-server-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_subnet_network_security_group_association.server-subnet-association]

  count = 2
}

# Primary Citrix ADC instance deployment
resource "azurerm_virtual_machine" "terraform-primary-adc-machine" {
  name                = "terraform-adc-machine-node-0"
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
  location            = var.location
  vm_size             = var.adc_vm_size

  network_interface_ids = [
    azurerm_network_interface.terraform-adc-management-interface[0].id,
    azurerm_network_interface.terraform-adc-client-interface[0].id,
    azurerm_network_interface.terraform-adc-server-interface[0].id,
  ]

  primary_network_interface_id = azurerm_network_interface.terraform-adc-management-interface[0].id

  os_profile {
    computer_name  = "Citrix-ADC-VPX-node-0"
    admin_username = var.adc_admin_username
    admin_password = var.adc_admin_password
    custom_data = base64encode(<<-EOF
    <NS-PRE-BOOT-CONFIG>
      <NS-CONFIG>
        set systemparameter -promptString "%u@%s"
        add ns ip ${azurerm_network_interface.terraform-adc-client-interface[0].private_ip_address} ${cidrnetmask(var.client_subnet_address_prefix)} -type SNIP
        add ns ip ${azurerm_network_interface.terraform-adc-server-interface[0].private_ip_address} ${cidrnetmask(var.server_subnet_address_prefix)} -type SNIP
        add ha node 1 ${azurerm_network_interface.terraform-adc-management-interface[1].private_ip_address} -inc ENABLED
        set ns rpcNode ${azurerm_network_interface.terraform-adc-management-interface[0].private_ip_address} -password ${var.citrixadc_rpc_node_password} -secure YES
        set ns rpcNode ${azurerm_network_interface.terraform-adc-management-interface[1].private_ip_address} -password ${var.citrixadc_rpc_node_password} -secure YES
      </NS-CONFIG>
    </NS-PRE-BOOT-CONFIG>
  EOF
  )
  }

  availability_set_id = azurerm_availability_set.terraform-availability-set.id

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      key_data = file(var.ssh_public_key_file)
      path     = format("/home/%v/.ssh/authorized_keys", var.adc_admin_username)
    }
  }

  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "terraform-citrixadc-os-disk-node-0"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  storage_image_reference {
    publisher = "citrix"
    offer     = "netscalervpx-131"
    sku       = "netscalervpxexpress"
    version   = "latest"
  }

  plan {
    name      = "netscalervpxexpress"
    publisher = "citrix"
    product   = "netscalervpx-131"
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.server-subnet-association,
    azurerm_subnet_network_security_group_association.client-subnet-association,
    azurerm_subnet_network_security_group_association.management-subnet-association,
    azurerm_network_interface_backend_address_pool_association.tf_assoc,
    azurerm_lb_rule.allow_http,
  ]

}

# Secondary Citrix ADC instance deployment
resource "azurerm_virtual_machine" "terraform-secondary-adc-machine" {
  name                = "terraform-adc-machine-node-1"
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
  location            = var.location
  vm_size             = var.adc_vm_size

  network_interface_ids = [
    azurerm_network_interface.terraform-adc-management-interface[1].id,
    azurerm_network_interface.terraform-adc-client-interface[1].id,
    azurerm_network_interface.terraform-adc-server-interface[1].id,
  ]

  primary_network_interface_id = azurerm_network_interface.terraform-adc-management-interface[1].id

  os_profile {
    computer_name  = "Citrix-ADC-VPX-node-1"
    admin_username = var.adc_admin_username
    admin_password = var.adc_admin_password
    custom_data = base64encode(<<-EOF
    <NS-PRE-BOOT-CONFIG>
      <NS-CONFIG>
        set systemparameter -promptString "%u@%s"
        add ns ip ${azurerm_network_interface.terraform-adc-client-interface[1].private_ip_address} ${cidrnetmask(var.client_subnet_address_prefix)} -type SNIP
        add ns ip ${azurerm_network_interface.terraform-adc-server-interface[1].private_ip_address} ${cidrnetmask(var.server_subnet_address_prefix)} -type SNIP
        add ha node 1 ${azurerm_network_interface.terraform-adc-management-interface[0].private_ip_address} -inc ENABLED
        set ns rpcNode ${azurerm_network_interface.terraform-adc-management-interface[0].private_ip_address} -password ${var.citrixadc_rpc_node_password} -secure YES
        set ns rpcNode ${azurerm_network_interface.terraform-adc-management-interface[1].private_ip_address} -password ${var.citrixadc_rpc_node_password} -secure YES
      </NS-CONFIG>
    </NS-PRE-BOOT-CONFIG>
  EOF
  )
  }

  availability_set_id = azurerm_availability_set.terraform-availability-set.id

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      key_data = file(var.ssh_public_key_file)
      path     = format("/home/%v/.ssh/authorized_keys", var.adc_admin_username)
    }
  }

  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "terraform-citrixadc-os-disk-node-1"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  storage_image_reference {
    publisher = "citrix"
    offer     = "netscalervpx-131"
    sku       = "netscalervpxexpress"
    version   = "latest"
  }

  plan {
    name      = "netscalervpxexpress"
    publisher = "citrix"
    product   = "netscalervpx-131"
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.server-subnet-association,
    azurerm_subnet_network_security_group_association.client-subnet-association,
    azurerm_subnet_network_security_group_association.management-subnet-association,
    azurerm_network_interface_backend_address_pool_association.tf_assoc,
    azurerm_lb_rule.allow_http,
    azurerm_virtual_machine.terraform-primary-adc-machine,
  ]
}

# Azure Load-balancer 
resource "azurerm_public_ip" "terraform-load-balancer-public-ip" {
  name                = "tf_lb_pubip"
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
  location            = var.location
  allocation_method   = "Static"

}

resource "azurerm_network_interface_backend_address_pool_association" "tf_assoc" {
  network_interface_id    = element(azurerm_network_interface.terraform-adc-client-interface.*.id, count.index)
  ip_configuration_name   = "client"
  backend_address_pool_id = azurerm_lb_backend_address_pool.tf_backend_pool.id

  count = 2
}

resource "azurerm_lb_rule" "allow_http" {
  loadbalancer_id                = azurerm_lb.tf_lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  enable_floating_ip             = true
  idle_timeout_in_minutes        = 4
  load_distribution              = "Default"
  probe_id                       = azurerm_lb_probe.tf_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.tf_backend_pool.id]
}

resource "azurerm_lb_backend_address_pool" "tf_backend_pool" {
  loadbalancer_id = azurerm_lb.tf_lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "tf_probe" {
  loadbalancer_id     = azurerm_lb.tf_lb.id
  name                = "http-probe"
  port                = 9000
  protocol            = "Tcp"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb" "tf_lb" {
  name                = "tf_lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.terraform-load-balancer-public-ip.id
  }
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "bastion" {
    virtual_machine_id = azurerm_linux_virtual_machine.terraform-ubuntu-machine.id
    location           = azurerm_resource_group.terraform-resource-group.location
    enabled            = true

    daily_recurrence_time = "1730"
    timezone              = "Eastern Standard Time"

    notification_settings {
      enabled          = false
    }
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "node-0" {
    virtual_machine_id = azurerm_virtual_machine.terraform-primary-adc-machine.id
    location           = azurerm_resource_group.terraform-resource-group.location
    enabled            = true

    daily_recurrence_time = "1730"
    timezone              = "Eastern Standard Time"

    notification_settings {
      enabled          = false
    }
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "node-1" {
    virtual_machine_id = azurerm_virtual_machine.terraform-secondary-adc-machine.id
    location           = azurerm_resource_group.terraform-resource-group.location
    enabled            = true

    daily_recurrence_time = "1730"
    timezone              = "Eastern Standard Time"

    notification_settings {
      enabled          = false
    }
}
