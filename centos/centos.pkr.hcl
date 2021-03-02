#
# ------------------------------------------------------------------------------
# CentOS Template for Packer
# ------------------------------------------------------------------------------
#
# Tyler Wayne © 2021
#

# Variable Definitions ---------------------------------------------------------

locals {
  iso_checksum = "07b94e6b1a0b0260b94c83d6bb76b26bf7a310dc78d7a9c7432809fb9bc6194a"
  iso_url = "/home/tyler/data/isos/centos/7/CentOS-7-x86_64-Minimal-2009.iso"
  output_directory = "/home/tyler/data/images/centos/7"
  preseed_file = "ks.cfg"
  ssh_password = "vagrant"
  ssh_username = "root"
  vm_name = "centos7-base.qcow2"
}

# Source -----------------------------------------------------------------------

source "qemu" "centos" {
  boot_command      = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${local.preseed_file}<enter><wait>"]
  accelerator       = "kvm"
  boot_wait         = "10s"
  disk_interface    = "virtio"
  disk_size         = "5000M"
  display           = "none"
  format            = "qcow2" # either qcow2 or raw
  headless          = "true" 
  http_directory    = "http"
  iso_checksum      = local.iso_checksum
  iso_url           = local.iso_url
  memory            = "2048"
  net_device        = "virtio-net"
  output_directory  = local.output_directory
  ssh_password      = local.ssh_password
  ssh_timeout       = "25m"
  ssh_username      = local.ssh_username
  vm_name           = local.vm_name
}

source "null" "centos" {
  ssh_host = "192.168.122.35"
  ssh_username = local.ssh_username
  ssh_password = local.ssh_password
}

# Build Images -----------------------------------------------------------------

build {
  sources = ["source.qemu.centos"]
  #sources = ["source.null.centos"]
  provisioner "shell" {
    execute_command = "echo '${local.ssh_password}' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    scripts = [
      "scripts/vagrant.sh",
      "scripts/cleanup.sh"
    ]
  }
  post-processor "vagrant" {
    keep_input_artifact = true
    output = "/home/tyler/data/boxes/centos7-base.box"
    provider_override = "libvirt"
  }
}

