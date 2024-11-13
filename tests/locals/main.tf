provider "azurerm" {
  features {
  }
}

locals {
  test_yaml = yamldecode(file("./tests/test.yaml"))
}

output "location" {
  value = "germanywestcentral"
}

output "azure" {
  value = local.test_yaml.azure
}

output "rg" {
  value = local.test_yaml.rg
}