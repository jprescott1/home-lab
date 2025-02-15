provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_domain" "default" {
  name = "testing123"
}
