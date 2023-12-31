######################################
## Active Directory NSG for Clients ##
######################################

# Create the security group for AD Users
resource "azurerm_network_security_group" "active-directory-client-nsg" {
  name                = "${replace(lower(var.app_name), " ", "-")}-${var.environment}-client-nsg"
  location            = azurerm_resource_group.terraform-resource-group.location
  resource_group_name = azurerm_resource_group.terraform-resource-group.name

  tags = {
    Name        = "${lower(var.app_name)}-${var.environment}-client-sg"
    description = "NSG for AD Clients"
    Environment = var.environment
  }
}

###################
## Inbound Rules ##
###################

# Port 53 DNS UDP
resource "azurerm_network_security_rule" "udp_53_client_inbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_53_DNS_UDP-DC${count.index+1}_Inbound"
  description                 = "AD_53_DNS_UDP-DC${count.index+1}_Inbound"
  priority                    = (150 + count.index)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = local.dns_servers[count.index]
  destination_address_prefix  = "*"
}

# Port 88 Kerberos TCP
resource "azurerm_network_security_rule" "tcp_88_client_inbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_88_Kerberos_TCP-DC${count.index+1}_Inbound"
  description                 = "AD_88_Kerberos_TCP-DC${count.index+1}_Inbound"
  priority                    = (160 + count.index)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "88"
  source_address_prefix       = local.dns_servers[count.index]
  destination_address_prefix  = "*"
}

# Port 135 RPC_TCP
resource "azurerm_network_security_rule" "tcp_135_client_inbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_135_RPC_TCP-DC${count.index+1}_Inbound"
  description                 = "AD_135_RPC_TCP-DC${count.index+1}_Inbound"
  priority                    = (170 + count.index)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "135"
  source_address_prefix       = local.dns_servers[count.index]
  destination_address_prefix  = "*"
}

# Port 389 LDAP TCP
resource "azurerm_network_security_rule" "tcp_389_client_inbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_389_LDAP_TCP-DC${count.index+1}_Inbound"
  description                 = "AD_389_LDAP_TCP-DC${count.index+1}_Inbound"
  priority                    = (180 + count.index)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = local.dns_servers[count.index]
  destination_address_prefix  = "*"
}

# Port 445 SMB TCP
resource "azurerm_network_security_rule" "tcp_445_client_inbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_445_SMB_TCP-DC${count.index+1}_Inbound"
  description                 = "AD_445_SMB_TCP-DC${count.index+1}_Inbound"
  priority                    = (190 + count.index)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "445"
  source_address_prefix       = local.dns_servers[count.index]
  destination_address_prefix  = "*"
}

# Port 49152-65535 TCP
resource "azurerm_network_security_rule" "tcp_49152-65535_client_inbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_49152-65535_TCP-DC${count.index+1}_Inbound"
  description                 = "AD_49152-65535_TCP-DC${count.index+1}_Inbound"
  priority                    = (200 + count.index)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "49152-65535"
  source_address_prefix       = local.dns_servers[count.index]
  destination_address_prefix  = "*"
}

# Port 49152-65535 UDP
resource "azurerm_network_security_rule" "udp_49152-65535_client_inbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_49152-65535_UDP-DC${count.index+1}_Inbound"
  description                 = "AD_49152-65535_UDP-DC${count.index+1}_Inbound"
  priority                    = (210 + count.index)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "49152-65535"
  source_address_prefix       = local.dns_servers[count.index]
  destination_address_prefix  = "*"
}

# Allow ping AD Domain Controllers
resource "azurerm_network_security_rule" "icmp_client_inbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_PingtoDC${count.index+1}_Inbound"
  description                 = "AD_PingtoDC${count.index+1}_Inbound"
  priority                    = (220 + count.index)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = local.dns_servers[count.index]
  destination_address_prefix  = "*"
}

####################
## Outbound Rules ##
####################

# Port 53 DNS UDP
resource "azurerm_network_security_rule" "udp_53_client_outbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_53_DNS_UDP-DC${count.index+1}_Outbound"
  description                 = "AD_53_DNS_UDP-DC${count.index+1}_Outbound"
  priority                    = (150 + count.index)
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = local.dns_servers[count.index]
}

# Port 88 Kerberos TCP
resource "azurerm_network_security_rule" "tcp_88_client_outbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_88_Kerberos_TCP-DC${count.index+1}_Outbound"
  description                 = "AD_88_Kerberos_TCP-DC${count.index+1}_Outbound"
  priority                    = (160 + count.index)
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "88"
  source_address_prefix       = "*"
  destination_address_prefix  = local.dns_servers[count.index]
}

# Port 135 RPC TCP
resource "azurerm_network_security_rule" "tcp_135_client_outbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_135_RPC_TCP-DC${count.index+1}_Outbound"
  description                 = "AD_135_RPC_TCP-DC${count.index+1}_Outbound"
  priority                    = (170 + count.index)
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "135"
  source_address_prefix       = "*"
  destination_address_prefix  = local.dns_servers[count.index]
}

# Port 389 LDAP TCP
resource "azurerm_network_security_rule" "tcp_389_client_outbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_389_LDAP_TCP-DC${count.index+1}_Outbound"
  description                 = "AD_389_LDAP_TCP-DC${count.index+1}_Outbound"
  priority                    = (180 + count.index)
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = "*"
  destination_address_prefix  = local.dns_servers[count.index]
}

# Port 445 SMB TCP
resource "azurerm_network_security_rule" "tcp_445_client_outbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_445_SMB_TCP-DC${count.index+1}_Outbound"
  description                 = "AD_445_SMB_TCP-DC${count.index+1}_Outbound"
  priority                    = (190 + count.index)
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "445"
  source_address_prefix       = "*"
  destination_address_prefix  = local.dns_servers[count.index]
}

# Port 49152-65535 TCP
resource "azurerm_network_security_rule" "tcp_49152-65535_client_outbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_49152-65535_TCP-DC${count.index+1}_Outbound"
  description                 = "AD_49152-65535_TCP-DC${count.index+1}_Outbound"
  priority                    = (200 + count.index)
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "49152-65535"
  source_address_prefix       = "*"
  destination_address_prefix  = local.dns_servers[count.index]
}

# Port 49152-65535 UDP
resource "azurerm_network_security_rule" "udp_49152-65535_client_outbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_49152-65535_UDP-DC${count.index+1}_Outbound"
  description                 = "AD_49152-65535_UDP-DC${count.index+1}_Outbound"
  priority                    = (210 + count.index)
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "49152-65535"
  source_address_prefix       = "*"
  destination_address_prefix  = local.dns_servers[count.index]
}

# Allow ping AD Domain Controllers
resource "azurerm_network_security_rule" "icmp_client_outbound" {
  depends_on = [azurerm_resource_group.terraform-resource-group]

  count = length(local.dns_servers)

  network_security_group_name = azurerm_network_security_group.active-directory-client-nsg.name
  resource_group_name         = azurerm_resource_group.terraform-resource-group.name
  name                        = "AD_PingtoDC${count.index+1}_Outbound"
  description                 = "AD_PingtoDC${count.index+1}_Outbound"
  priority                    = (220 + count.index)
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = local.dns_servers[count.index]
}