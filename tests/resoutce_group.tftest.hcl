provider "azurerm" {
  subscription_id = "db0b8e0e-a0db-4596-8cd7-ff7519bd2ba1" # sub-wpp-wppit-lz-cap-x-001
  features {
  }
}

# locals {
## NOT SUPPORTED
# }

# mocks
override_resource {
  target = azurerm_resource_group.this
}

# arrange - these are the default variables and can be overridden in runs
variables {
  name     = "Test-RGx"
  location = "uksouth" # var.test_locals.location 
  tags = {
    "env" = "Testx"
  }
}

# gives us run.locals.azure and run.locals.rg
run "locals" {
  module {
    source = "./tests/locals"
  }
}

# action
run "resource_group_name_check" {
  command = plan

  variables {
    name = run.locals.rg.name
  }

  assert {
    # this looks self-referential, but we are testing that the module consumes the value of the name variable
    condition     = azurerm_resource_group.this.name == run.locals.rg.name # "Test-RG"
    error_message = "Wrong Resource Group Name"
  }
}

run "location_check" {
  command = plan

  variables {
    location = run.locals.azure.location
  }

  assert {
    condition     = azurerm_resource_group.this.location == run.locals.azure.location
    error_message = "Wrong Location"
  }
}

run "tags_check" {
  command = plan
  variables {
    tags = run.locals.rg.tags
  }

  assert {
    # note that run.locals.rg.tags is an object, but azurerm_resource_group.this.tags is map of string - hence tomap() is required to coerce the type
    condition = azurerm_resource_group.this.tags == tomap(run.locals.rg.tags)

    error_message = "Wrong Tags"
  }
}