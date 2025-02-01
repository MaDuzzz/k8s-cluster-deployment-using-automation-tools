terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

provider "openstack" {
  user_name   = nonsensitive(var.openstack_configuration.user_name)
  tenant_name = nonsensitive(var.openstack_configuration.tenant_name)
  password    = var.openstack_configuration.password
  auth_url    = nonsensitive(var.openstack_configuration.auth_url)
  region      = nonsensitive(var.openstack_configuration.region)
}
