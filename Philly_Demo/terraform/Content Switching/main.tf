
resource "citrixadc_nsfeature" "tf_nsfeature" {
    cs = true
    lb = true
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

resource "citrixadc_service" "web-server-red" {
  name        = var.service1_name
  port        = var.service1_port
  ip          = var.service1_ip
  servicetype = var.service1_servicetype
}

resource "citrixadc_lbvserver_service_binding" "lb_binding1" {
  name        = citrixadc_lbvserver.tf_lbvserver1.name
  servicename = citrixadc_service.web-server-red.name
}

resource "citrixadc_lbvserver" "tf_lbvserver2" {
  name        = var.lbvserver2_name
  servicetype = var.lbvserver2_servicetype
}

resource "citrixadc_service" "web-server-green" {
  name        = var.service2_name
  port        = var.service2_port
  ip          = var.service2_ip
  servicetype = var.service2_servicetype
}

resource "citrixadc_lbvserver_service_binding" "lb_binding2" {
  name        = citrixadc_lbvserver.tf_lbvserver2.name
  servicename = citrixadc_service.web-server-red.name
}