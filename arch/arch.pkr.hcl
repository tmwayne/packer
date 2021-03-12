#
# ------------------------------------------------------------------------------
# ArchLinux Template for Packer
# ------------------------------------------------------------------------------
#
# Tyler Wayne © 2021
#

# Variables --------------------------------------------------------------------

locals {
  iso_checksum = "md5:954ccc00409d564938433611e3a81ae9"
  iso_url = "/home/tyler/data/isos/arch/archlinux-2021.03.01-x86_64.iso"
  output_directory = "/home/tyler/data/images/arch/x86_64"
  ssh_password = "vagrant"
  ssh_username = "vagrant"
  vm_name = "arch-base.qcow2"
  disk_size = "5000M"
  memory = "2048"
}

# Source -----------------------------------------------------------------------

source "qemu" "arch" {
  boot_command = [
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
  headless          = "true" 
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

# Build Images -----------------------------------------------------------------

build {
  sources = ["source.qemu.arch"]
  provisioner "shell" {
    execute_command = "echo '${local.ssh_password}' | {{ .Vars }} sudo -E -S bash {{ .Path }}"
    script = "scripts/setup.sh"
    expect_disconnect = true
  }
  provisioner "shell" {
    execute_command = "echo '${local.ssh_password}' | {{ .Vars }} sudo -E -S bash {{ .Path }}"
    script = "scripts/cleanup.sh"
  }
  post-processor "vagrant" {
    keep_input_artifact = true
    output = "/home/tyler/data/boxes/arch/arch-base.box"
    provider_override = "libvirt"
    # vagrantfile_template = "./vagrantfile.template"
  }
  

}
