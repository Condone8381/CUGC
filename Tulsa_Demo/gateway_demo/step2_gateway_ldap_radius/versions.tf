terraform {
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
    }
  }
}
provider "citrixadc" {
  endpoint             = "http://4.155.48.40"
  username             = "nsroot" # NS_LOGIN env variable
  password             = "CUGCDemo123!" # NS_PASSWORD env variable
  insecure_skip_verify = true
}