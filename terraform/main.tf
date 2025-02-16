terraform {
  backend "gcs" {
    bucket = "gha-lab-bucket"
    prefix = "./tf-deploy"
  }
}

module "worker_node" {
  source   = "github.com/jprescott1/terraform-libvirt-module"
  vm_name  = "worker-node"
  vm_count = 3
  memory   = 4096
  vcpu     = 2
}

module "control_plane" {
  source   = "github.com/jprescott1/terraform-libvirt-module"
  vm_name  = "control-plane"
  vm_count = 1
  memory   = 4096
  vcpu     = 2
}
