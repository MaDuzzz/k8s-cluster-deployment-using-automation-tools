variable "openstack_configuration" {
  type = object({
    user_name   = string
    tenant_name = string
    password    = string
    auth_url    = string
    region      = string
  })
  sensitive = true
}
