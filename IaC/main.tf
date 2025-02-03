resource "openstack_networking_secgroup_v2" "k8s_secgrp" {
  name        = "k8s-secgrp"
  description = "K8s security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgrp_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.k8s_secgrp.id
}

resource "openstack_networking_secgroup_rule_v2" "secgrp_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.k8s_secgrp.id
}

resource "openstack_networking_secgroup_rule_v2" "secgrp_rule_3" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.k8s_secgrp.id
}

data "openstack_networking_network_v2" "mgnt_network" {
  name = "mgnt-network"
}

data "openstack_images_image_v2" "ubuntu_vm_image" {
  name = "cloud-image"
}

resource "openstack_compute_flavor_v2" "k8s_master_flavor" {
  name      = "master-flavor"
  ram       = "4096"
  vcpus     = "4"
  disk      = "20"
  is_public = true
}

resource "openstack_compute_flavor_v2" "k8s_worker_flavor" {
  name      = "worker-flavor"
  ram       = "4096"
  vcpus     = "2"
  disk      = "20"
  is_public = true
}

resource "openstack_compute_instance_v2" "k8s_master_compute" {
  name            = "master-compute"
  image_id        = data.openstack_images_image_v2.ubuntu_vm_image.id
  flavor_id       = openstack_compute_flavor_v2.k8s_master_flavor.id
  security_groups = [openstack_networking_secgroup_v2.k8s_secgrp.name]

  network {
    name = data.openstack_networking_network_v2.mgnt_network.name
  }
}

resource "openstack_compute_instance_v2" "k8s_worker_compute" {
  for_each        = var.k8s_worker_compute
  name            = each.value
  image_id        = data.openstack_images_image_v2.ubuntu_vm_image.id
  flavor_id       = openstack_compute_flavor_v2.k8s_worker_flavor.id
  security_groups = [openstack_networking_secgroup_v2.k8s_secgrp.name]

  network {
    name = data.openstack_networking_network_v2.mgnt_network.name
  }
}
