terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.6"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

terraform {
  backend "gcs" {
    bucket = "gha-lab-bucket"
    prefix = "./lab-deploy"
  }
}

resource "libvirt_domain" "control_plane" {
  name   = "control-plane01"
  memory = "4096"
  vcpu   = 4
  disk {
    volume_id = libvirt_volume.control_plane_root.id
  }
  network_interface {
    bridge = "br0"
  }
  cloudinit = libvirt_cloudinit.control_plane_cloudinit.id
}

resource "libvirt_volume" "control_plane_root" {
  name   = "control-plane01-root"
  pool   = "default"
  size   = 100 * 1024 * 1024 * 1024 # 100 GB
  format = "qcow2"
  source = "/home/jimmy/images/ubuntu-22.04-server-cloudimg-amd64.img"
}

resource "libvirt_cloudinit" "control_plane_cloudinit" {
  name      = "control-plane01-cloudinit"
  user_data = <<-EOF
#cloud-config
hostname: control-plane01
users:
  - name: jimmy
    groups: sudo
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqCNHKusEfJmWp7PQcGhgFWBWAq3RBKn9dXoZJMO+Ri jimmy@dev-lab
password: your_secure_password # Consider using ssh keys instead
chpasswd:
  list: |
    jimmy:$6$rounds=656000$your_salt$hashed_password
    root:$6$rounds=656000$another_salt$another_hashed_password
  expire: False
network:
  version: 2
  ethernets:
    ens3:
      dhcp4: false
      addresses:
        - 192.168.10.54/24
      gateway4: 192.168.10.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
runcmd:
  - [ systemctl, enable, --now, qemu-guest-agent.service ]
EOF
}
