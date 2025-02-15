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
  filename = "/home/jimmy/itworks.txt"
  content  = "Hello, Terraform!"
}