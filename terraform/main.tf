terraform {
  backend "gcs" {
    bucket = "gha-lab-bucket"
    prefix = "./tf-deploy"
  }
}

module "libvirt_vm" {
  source   = "github.com/jprescott1/terraform-libvirt-module"
  vm_name  = "ubuntu-vm"
  vm_count = 3
  memory   = 1024
  vcpu     = 2
}
