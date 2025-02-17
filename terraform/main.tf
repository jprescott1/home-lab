terraform {
  backend "gcs" {
    bucket = "gha-lab-bucket"
    prefix = "./tf-deploy"
  }
}

resource "libvirt_pool" "ubuntu" {
  name = "cluster"
  type = "dir"
  target {
    path = "/var/lib/libvirt/cluster_images"
  }
}

module "control_plane" {
  source   = "github.com/jprescott1/terraform-libvirt-module"
  vm_name  = "control-plane"
  vm_count = 1
  memory   = 4096
  vcpu     = 2
  pool_name = libvirt_pool.ubuntu.name
}
