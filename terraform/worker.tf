module "worker_node" {
  source   = "github.com/jprescott1/terraform-libvirt-module"
  vm_name  = "control-plane"
  vm_count = 1
  memory   = 4096
  vcpu     = 2
}
