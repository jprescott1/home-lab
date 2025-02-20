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

module "vm" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.12.0"

  vm_hostname_prefix = "server"
  vm_count           = 1
  memory             = "2048"
  vcpu               = 1
  system_volume      = 20
  dhcp               = true
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqCNHKusEfJmWp7PQcGhgFWBWAq3RBKn9dXoZJMO+Ri jimmy@dev-lab",
  ]
  time_zone  = "CET"
  os_img_url = "file:///home/jimmy/images/ubuntu-22.04-server-cloudimg-amd64.img"
}