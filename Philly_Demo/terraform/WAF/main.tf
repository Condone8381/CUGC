
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

resource "citrixadc_appfwprofile" "tf_appfwprofile1" {
  name           = "tf_appfwprofile1"
  addcookieflags = "none"
  bufferoverflowaction = [
    "block",
    "log",
    "stats",
  ]
  canonicalizehtmlresponse = "ON"
  checkrequestheaders      = "OFF"
  cmdinjectionaction = [
    "block",
    "log",
    "stats",
  ]
  contenttypeaction = [
    "none",
  ]
  cookieconsistencyaction = [
    "none",
  ]
  cookieencryption = "none"
  cookiehijackingaction = [
    "none",
  ]
  cookieproxying   = "none"
  cookietransforms = "OFF"
  creditcard = [
    "none",
  ]
  creditcardaction = [
    "none",
  ]
  creditcardxout = "OFF"
  crosssitescriptingaction = [
    "block",
    "log",
    "stats",
  ]
  crosssitescriptingcheckcompleteurls   = "OFF"
  crosssitescriptingtransformunsafehtml = "OFF"
  csrftagaction = [
    "none",
  ]
  defaultcharset = "iso-8859-1"
  denyurlaction = [
    "block",
    "log",
    "stats",
  ]
  dosecurecreditcardlogging = "ON"
  dynamiclearning = [
    "none",
  ]
  enableformtagging                   = "ON"
  errorurl                            = "/"
  excludefileuploadfromchecks         = "OFF"
  exemptclosureurlsfromsecuritychecks = "ON"
  fieldconsistencyaction = [
    "none",
  ]
  fieldformataction = [
    "block",
    "log",
    "stats",
  ]
  fileuploadtypesaction = [
    "block",
    "log",
    "stats",
  ]
  htmlerrorobject = " "
  infercontenttypexmlpayloadaction = [
    "none",
  ]
  inspectcontenttypes = [
    "application/x-www-form-urlencoded",
    "multipart/form-data",
    "text/x-gwt-rpc",
  ]
  invalidpercenthandling = "secure_mode"
  jsondosaction = [
    "block",
    "log",
    "stats",
  ]
  jsonerrorobject = " "
  jsonsqlinjectionaction = [
    "block",
    "log",
    "stats",
  ]
  jsonsqlinjectiontype = "SQLSplCharANDKeyword"
  jsonxssaction = [
    "block",
    "log",
    "stats",
  ]
  logeverypolicyhit = "ON"
  multipleheaderaction = [
    "block",
    "log",
  ]
  optimizepartialreqs      = "ON"
  percentdecoderecursively = "OFF"
  postbodylimitaction = [
    "block",
    "log",
    "stats",
  ]
  refererheadercheck          = "OFF"
  responsecontenttype         = "application/octet-stream"
  rfcprofile                  = "APPFW_RFC_BLOCK"
  semicolonfieldseparator     = "OFF"
  sessionlessfieldconsistency = "OFF"
  sessionlessurlclosure       = "OFF"
  signatures                  = " "
  sqlinjectionaction = [
    "block",
    "log",
    "stats",
  ]
  sqlinjectionchecksqlwildchars     = "OFF"
  sqlinjectionparsecomments         = "checkall"
  sqlinjectiontransformspecialchars = "OFF"
  sqlinjectiontype                  = "SQLSplCharANDKeyword"
  starturlaction = [
    "log",
  ]
  starturlclosure   = "OFF"
  streaming         = "OFF"
  striphtmlcomments = "none"
  stripxmlcomments  = "none"
  trace             = "OFF"
  type = [
    "HTML",
    "JSON",
    "XML",
  ]
  urldecoderequestcookies = "OFF"
  usehtmlerrorobject      = "OFF"
  verboseloglevel         = "pattern"
  xmlattachmentaction = [
    "block",
    "log",
    "stats",
  ]
  xmldosaction = [
    "block",
    "log",
    "stats",
  ]
  xmlerrorobject = " "
  xmlformataction = [
    "block",
    "log",
    "stats",
  ]
  xmlsoapfaultaction = [
    "block",
    "log",
    "stats",
  ]
  xmlsqlinjectionaction = [
    "block",
    "log",
    "stats",
  ]
  xmlsqlinjectionchecksqlwildchars = "OFF"
  xmlsqlinjectionparsecomments     = "checkall"
  xmlsqlinjectiontype              = "SQLSplCharANDKeyword"
  xmlvalidationaction = [
    "none",
  ]
  xmlwsiaction = [
    "none",
  ]
  xmlxssaction = [
    "none",
  ]
}
resource "citrixadc_appfwpolicy" "tf_appfwpolicy1" {
  name        = var.appfwpolicy1_name
  profilename = citrixadc_appfwprofile.tf_appfwprofile1.name
  rule        = var.appfwpolicy1_rule
}

resource "citrixadc_lbvserver_appfwpolicy_binding" "tf_bind1" {
  name                   = citrixadc_lbvserver.tf_lbvserver1.name
  policyname             = citrixadc_appfwpolicy.tf_appfwpolicy1.name
  priority               = 100
  gotopriorityexpression = "END"
}
