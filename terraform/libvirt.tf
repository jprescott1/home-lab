provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_domain" "default" {
  name = "test"
}

resource "libvirt_domain" "test2" {
  name = "test2"
}