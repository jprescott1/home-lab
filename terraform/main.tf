terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

terraform {
  backend "gcs" {
    bucket = "gha-lab-bucket"
    prefix = "./lab-deploy"
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "k8s_pool" {
  name = "k8s_pool"
  type = "dir"
  target {
    path = "/home/jimmy/pools"
  }
}

module "vm1" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.12.0"

  vm_hostname_prefix = "control-plane"
  vm_count           = 0
  memory             = "4096"
  vcpu               = 4
  system_volume      = 100
  dhcp               = true
  ssh_admin          = "jimmy"
  ssh_private_key    = "/home/jimmy/.ssh/id_ed25519"
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqCNHKusEfJmWp7PQcGhgFWBWAq3RBKn9dXoZJMO+Ri jimmy@dev-lab",
  ]
  time_zone  = "UTC"
  os_img_url = "file:///home/jimmy/images/ubuntu-22.04-server-cloudimg-amd64.img"
}

module "vm2" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.12.0"

  vm_hostname_prefix = "worker-node"
  vm_count           = 1
  memory             = "4096"
  vcpu               = 4
  pool               = "k8s_pool"
  system_volume      = 50
  dhcp               = false
  ip_address = [
    "192.168.10.100"
  ]
  ip_gateway         = "192.168.10.1"
  ip_nameserver      = "8.8.8.8"
  local_admin        = "admin"
  local_admin_passwd = "$6$rounds=4096$OdjRRHAa7p4ISvF0$7yLgil3eb4oNiIjJb34SQd0BZOL8uF94xUCw3nb2Z2FtNzSbYp/cIOx7WEMj3b5vqpsoByuE6.OfRvBUh8KlH0"
  ssh_admin          = "jimmy"
  ssh_private_key    = "/home/jimmy/.ssh/id_ed25519"
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqCNHKusEfJmWp7PQcGhgFWBWAq3RBKn9dXoZJMO+Ri jimmy@dev-lab",
  ]
  time_zone  = "UTC"
  os_img_url = "file:///home/jimmy/images/ubuntu-22.04-server-cloudimg-amd64.img"

}
