#
# ------------------------------------------------------------------------------
# ArchLinux Template for Packer
# ------------------------------------------------------------------------------
#
# Tyler Wayne © 2021
#

# Variable Definitions ---------------------------------------------------------



locals {
  iso_checksum = "md5:954ccc00409d564938433611e3a81ae9"
  iso_url = "/home/tyler/data/isos/arch/archlinux-2021.03.01-x86_64.iso"
  output_directory = "/home/tyler/data/images/arch/x86_64"
  # preseed_file = "ks.cfg"
  # ssh_host = "192.168.122.20"
  ssh_password = "vagrant"
  ssh_username = "vagrant"
  vm_name = "arch-base.qcow2"
  disk_size = "5000M"
  memory = "2048"
}

# Source -----------------------------------------------------------------------

source "qemu" "arch" {
  boot_command = [
    # "<enter><wait5>",
    "<enter><wait10><wait10><wait10><wait10><wait10><wait10><wait10>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait5>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/poweroff.timer<enter><wait5>",
    "/usr/bin/bash ./enable-ssh.sh<enter>"
  ]
  accelerator       = "kvm"
  boot_wait         = "10s"
  disk_interface    = "virtio"
  disk_size         = local.disk_size
  display           = "none"
  format            = "qcow2" 
  headless          = "false" 
  http_directory    = "http"
  iso_checksum      = local.iso_checksum
  iso_url           = local.iso_url
  memory            = local.memory
  net_device        = "virtio-net"
  output_directory  = local.output_directory
  ssh_password      = local.ssh_password
  ssh_timeout       = "25m"
  ssh_username      = local.ssh_username
  vm_name           = local.vm_name
}

source "null" "centos" {
  ssh_host = local.ssh_host
  ssh_username = local.ssh_username
  ssh_password = local.ssh_password
}

# Build Images -----------------------------------------------------------------

build {
  sources = ["source.qemu.arch"]
#   provisioner "file" {
#     source = "http/sudoers.tyler"
#     destination = "/tmp/sudoers.tyler"
#   }

}
