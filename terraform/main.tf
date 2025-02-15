terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "local" {}

resource "local_file" "itworks" {
  filename = "/home/jimmy/itworksagain6.txt"
  content  = "Hello, Terraform!"
}