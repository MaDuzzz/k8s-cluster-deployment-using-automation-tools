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

variable "k8s_worker_compute" {
  type    = set(any)
  default = ["k8s-worker-node1", "k8s-worker-node2"]
}
