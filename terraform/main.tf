terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    libvirt = {
      source  = "nv6/libvirt"
      version = "0.7.1"
    }
  }
}

provider "local" {}

resource "local_file" "itworks" {
  filename = "/home/jimmy/itworksagain5.txt"
  content  = "Hello, Terraform!"
}