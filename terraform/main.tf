terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "vmpool" {
  name = "cloud-pool"
  type = "dir"
  path = "${path.module}/volume"
}

resource "libvirt_volume" "vm-qcow2" {
  name   = "guest.qcow2"
  pool   = libvirt_pool.vmpool.name
  source = "${path.module}/sources/guest.qcow2"
  format = "qcow2"
}

module "vm" {
  source  = "MonolithProjects/vm/libvirt"
  version = "1.12.0"

  vm_hostname_prefix = "server"
  vm_count           = 1
  memory             = "2048"
  vcpu               = 1
  pool               = "cloud-pool"
  system_volume      = 20
  dhcp               = true
  local_admin        = "local-admin"
  ssh_admin          = "ci-user"
  ssh_private_key    = "~/.ssh/id_ed25519"
  local_admin_passwd = "$6$rounds=4096$XB9Gy/7WNzwW6MgO$b/WqUk9vcs/sblEz4jJ2omW6/rmaX9oausQfVozVnnCHyrXFTnRYS7gmq5emWFreZ1Ddqeq.qqK83z88pbs9C1"
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsycFZCGi6778LPkAq2I9RJlmkNrMwEEiZvGwWp5tvg jimmyjorts@gloogleegloo.com",
  ]
  time_zone  = "CET"
  os_img_url = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
}
