variable "lbvserver1_name" {
  type        = string
  description = "lb vserver1 name"
}
variable "lbvserver1_servicetype" {
  description = "lb vserver1 Servicetype"
}

variable "lbvserver2_name" {
  type        = string
  description = "lb vserver2 name"
}
variable "lbvserver2_servicetype" {
  description = "lb vserver2 Servicetype"
}

variable "service1_name" {
  type        = string
  description = "Service1 name"
}
variable "service1_ip" {
  type        = string
  description = "Service1 ip"
}
variable "service1_servicetype" {
  description = "Service1 Servicetype"
}
variable "service1_port" {
  type        = number
  description = "Service1 Port"
}

variable "service2_name" {
  type        = string
  description = "Service2 name"
}
variable "service2_ip" {
  type        = string
  description = "Service2 ip"
}
variable "service2_servicetype" {
  description = "Service2 Servicetype"
}
variable "service2_port" {
  type        = number
  description = "Service2 Port"
}

variable "cspolicy1_name" {
  type        = string
  description = "CS policy1 name"
}
variable "cspolicy1_rule" {
  description = "CS Policy1 Rule"
}

variable "cspolicy2_name" {
  type        = string
  description = "CS policy2 name"
}
variable "cspolicy2_rule" {
  description = "CS Policy2 Rule"
}

variable "csvserver_name" {
  type        = string
  description = "CS vserver name"
}
variable "csvserver_ipv46" {
  type        = string
  description = "CS vserver ip"
}
variable "csvserver_servicetype" {
  description = "CS vserver Servicetype"
}
variable "csvserver_port" {
  type        = number
  description = "CS vserver Port"
}

variable "appfwpolicy1_name" {
  type        = string
  description = "Appfw Policy1 name"
}
variable "appfwpolicy1_rule" {
  type        = string
  description = "Appfw Policy1 rule"
}
variable "appfwprofile1_name" {
  type        = string
  description = "Appfw Profile1 rule"
}