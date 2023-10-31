
resource "citrixadc_nsfeature" "tf_nsfeature" {
    cs        = true
    lb        = true
    appfw     = true
}

resource "citrixadc_nsip" "snip" {
  ipaddress = "10.0.1.6"
  type      = "SNIP"
  netmask   = "255.255.255.0"
}

resource "citrixadc_lbvserver" "tf_lbvserver1" {
  name        = var.lbvserver1_name
  servicetype = var.lbvserver1_servicetype
}

resource "citrixadc_service" "web-echoserver1" {
  name        = var.service1_name
  port        = var.service1_port
  ip          = var.service1_ip
  servicetype = var.service1_servicetype
}

resource "citrixadc_lbvserver_service_binding" "lb_binding1" {
  name        = citrixadc_lbvserver.tf_lbvserver1.name
  servicename = citrixadc_service.web-echoserver1.name
}

resource "citrixadc_lbvserver" "tf_lbvserver2" {
  name        = var.lbvserver2_name
  servicetype = var.lbvserver2_servicetype
}

resource "citrixadc_service" "web-echoserver2" {
  name        = var.service2_name
  port        = var.service2_port
  ip          = var.service2_ip
  servicetype = var.service2_servicetype
}

resource "citrixadc_lbvserver_service_binding" "lb_binding2" {
  name        = citrixadc_lbvserver.tf_lbvserver2.name
  servicename = citrixadc_service.web-echoserver2.name
}

resource "citrixadc_csaction" "tf_csaction1" {
  name            = "tf_csaction1"
  targetlbvserver = citrixadc_lbvserver.tf_lbvserver1.name
}
resource "citrixadc_cspolicy" "tf_policy_echoserver1" {
  policyname = var.cspolicy1_name
  rule       = var.cspolicy1_rule
  action     = citrixadc_csaction.tf_csaction1.name
}

resource "citrixadc_csaction" "tf_csaction2" {
  name            = "tf_csaction2"
  targetlbvserver = citrixadc_lbvserver.tf_lbvserver2.name
}
resource "citrixadc_cspolicy" "tf_policy_echoserver2" {
  policyname = var.cspolicy2_name
  rule       = var.cspolicy2_rule
  action     = citrixadc_csaction.tf_csaction2.name
}

resource "citrixadc_csvserver" "tf_csvserver" {
  ipv46       = var.csvserver_ipv46
  name        = var.csvserver_name
  port        = var.csvserver_port
  servicetype = var.csvserver_servicetype
}

resource "citrixadc_csvserver_cspolicy_binding" "tf_csvscspolbind_echoserver1" {
  name       = citrixadc_csvserver.tf_csvserver.name
  policyname = citrixadc_cspolicy.tf_policy_echoserver1.policyname
  priority   = 100
}
resource "citrixadc_csvserver_cspolicy_binding" "tf_csvscspolbind_echoserver2" {
  name       = citrixadc_csvserver.tf_csvserver.name
  policyname = citrixadc_cspolicy.tf_policy_echoserver2.policyname
  priority   = 110
}

