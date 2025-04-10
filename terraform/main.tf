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

# resource "libvirt_pool" "vmpool" {
#   name = "debug-pool"
#   type = "dir"
#   target {
#     path = "${path.module}/volume"
#   }
# }

# resource "libvirt_volume" "vm-qcow2" {
#   name   = "guest.qcow2"
#   pool   = libvirt_pool.vmpool.name
#   source = "${path.module}/sources/guest.qcow2"
#   format = "qcow2"
# }

module "vm1" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.12.0"

  vm_hostname_prefix = "control-plane"
  vm_count           = 3
  memory             = "2049"
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
  vm_count           = 5
  memory             = "3024"
  vcpu               = 4
  system_volume      = 20
  dhcp               = true
  ssh_admin          = "jimmy"
  ssh_private_key    = "/home/jimmy/.ssh/id_ed25519"
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqCNHKusEfJmWp7PQcGhgFWBWAq3RBKn9dXoZJMO+Ri jimmy@dev-lab",
  ]
  time_zone  = "UTC"
  os_img_url = "file:///home/jimmy/images/ubuntu-22.04-server-cloudimg-amd64.img"
}
