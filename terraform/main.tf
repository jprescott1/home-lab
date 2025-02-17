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
    prefix = "./tf-deploy"
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "test_nodes" {
  source             = "MonolithProjects/vm/libvirt"
  vm_hostname_prefix = "test"
  autostart          = false
  vm_count           = 1
  index_start        = 1
  memory             = "512"
  vcpu               = 1
  system_volume      = 20
  graphics           = "vnc"
  ssh_admin          = "admin"
  ssh_private_key    = "~/.ssh/id_ed25519"
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILIJ2/7bvjNBsr/VGNJTbgx9UPyCPjwxf8Ie8d30a4+l jimmy@lab-host",
  ]
  local_admin        = "localadmin"
  local_admin_passwd = "<yout password hash (mkpasswd --method=SHA-512 --rounds=4096)>"
}

output "output_data" {
  value = module.test_nodes
}
