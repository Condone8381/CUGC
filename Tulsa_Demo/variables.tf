variable "resource_group_name" {
  description = "Name for the existing resource group ADC is deployed in."
  default     = "cugc-demos-louisville"
}

variable "location" {
  description = "Azure location where all resources will be created."
}

variable "server_subnet_id" {
  description = "Server subent id. This where the web server interface will be created."
}

variable "management_subnet_id" {
  description = "Management subnet id."
}

variable "ssh_public_key_file" {
  description = "Public key file for accessing the ubuntu machine."
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_private_key_file" {
  description = "Private key file for accessing the ubuntu machine."
  default     = "~/.ssh/id_ed25519"
}

variable "admin_user" {
  description = "Admin user name for ubuntu machine."
  default     = "adminuser"
}

variable "vm_size" {
  description = "Size for the ubuntu machine. Must allow for 2 NICs"
  default     = "Standard_A1_v2"
}

variable "num_services" {
  description = "Number of backend services to instantiate"
  default     = 2
}

variable "private_vip" {
  description = "Private ip address of the Citrix ADC client interface"
}

variable "nsip" {
  description = "NSIP to be used with the citrixadc provider."
}

variable "ubuntu_setup_wait_sec" {
  description = "Wait period before starting to setup backend ubuntu node"
  default     = 120
}

variable "adc_admin_username" {
  description = "User name for the Citrix ADC admin user."
  default     = "nsroot"
}

variable "adc_admin_password" {
  description = "Password for the Citrix ADC admin user. Must be sufficiently complex to pass azurerm provider checks."
}

variable "citrixadc_rpc_node_password" {
  description = "The new ADC RPC node password that will replace the default one on both ADC instances. [Learn More about RPCNode](https://docs.citrix.com/en-us/citrix-adc/current-release/getting-started-with-citrix-adc/change-rpc-node-password.html)"
}

variable "virtual_network_address_space" {
  description = "Address space for the virtual network."
}

variable "management_subnet_address_prefix" {
  description = "The address prefix that will be used for the management subnet. Must be contained inside the VNet address space"
}

variable "client_subnet_address_prefix" {
  description = "The address prefix that will be used for the client subnet. Must be contained inside the VNet address space"
}

variable "server_subnet_address_prefix" {
  description = "The address prefix that will be used for the server subnet. Must be contained inside the VNet address space"
}

variable "controlling_subnet" {
  description = "The CIDR block of the machines that will be allowed access to the management subnet."
}

variable "adc_vm_size" {
  description = "Size for the ADC machine. Must allow for 3 NICs."
  default     = "Standard_DS3_v2"
}