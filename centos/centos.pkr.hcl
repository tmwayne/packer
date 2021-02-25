#
# ------------------------------------------------------------------------------
# CentOS Template for Packer
# ------------------------------------------------------------------------------
#
# Tyler Wayne © 2021
#

# Variable Definitions ---------------------------------------------------------

variable "iso_checksum" { type = string }
variable "iso_url" { type = string }
variable "output_directory" { type = string }
variable "preseed_file" { type = string }
variable "ssh_password" {
  type = string
  sensitive = true
}
variable "ssh_username" { type = string }
variable "vm_name" { type = string }

locals {
  auth_file = "/home/tyler/.ssh/authorized_keys"
  sshd_file = "/etc/ssh/sshd_config"
}

# Source -----------------------------------------------------------------------

source "qemu" "centos" {
  boot_command      = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file}<enter><wait>"]
  accelerator       = "kvm"
  boot_wait         = "10s"
  disk_interface    = "virtio"
  disk_size         = "5000M"
  display           = "none"
  format            = "raw" # either qcow2 or raw
  headless          = "true" 
  http_directory    = "http"
  iso_checksum      = var.iso_checksum
  iso_url           = var.iso_url
  memory            = "2048"
  net_device        = "virtio-net"
  output_directory  = var.output_directory
  ssh_password      = var.ssh_password
  ssh_timeout       = "20m"
  ssh_username      = var.ssh_username
  vm_name           = var.vm_name
}

source "null" "centos" {
  ssh_host = "192.168.122.35"
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
}

# Build Images -----------------------------------------------------------------

build {
  sources = ["source.qemu.centos"]
  #sources = ["source.null.centos"]
  provisioner "file" {
    source = "/home/tyler/.ssh/keys/centos.pub"
    destination = local.auth_file
  }
  provisioner "shell" {
    inline = [
      "chown tyler:tyler ${local.auth_file} && chmod 0600 ${local.auth_file}",
      "sed 's/^PasswordAuthentication.*/PasswordAuthentication no/' ${local.sshd_file} > ${local.sshd_file}.tmp",
      "mv ${local.sshd_file}.tmp ${local.sshd_file}"
    ]
  }
}

