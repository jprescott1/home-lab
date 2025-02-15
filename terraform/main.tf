terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "local" {}

resource "local_file" "itworks" {
  filename = "/home/jimmy/itworksagain3.txt"
  content  = "Hello, Terraform!"
}