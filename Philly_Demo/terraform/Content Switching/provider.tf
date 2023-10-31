terraform {
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
    }
  }
}
provider "citrixadc" {
  endpoint = "http://4.154.110.157"
  username = "nsroot"
  password = "CUGCDemo123!"
}