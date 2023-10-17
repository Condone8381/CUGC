terraform {
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
    }
  }
}
provider "citrixadc" {
  endpoint = "http://4.155.48.40"
  username = "nsroot"
  password = "CUGCDemo123!"
}