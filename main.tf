

/* yes */
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.13.0"
  features {}
}

provider "random" {
  version="2.2.0"
}

provider "azuread" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=0.7.0"
}


locals {
  app_name = "testapp"
  env_name = "dev"
}


module "resource_group" {
  
  source                = "github.com/markti/tf_azure_resourcegroup/base"

  name  = "${local.app_name}-${local.env_name}"
  location = "East US"
  app_name              = local.app_name
  env_name              = local.env_name

}


module "api_hosting_plan" {
  
  source                = "github.com/markti/tf_azure_appservice/plan/premium"

  app_name              = local.app_name
  env_name              = local.env_name
  
  name                  = "${local.app_name}-${local.env_name}-plan"
  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location

  storage_type          = "GRS"

  minimum_instance_count = 2
  maximum_instance_count = 5

}
