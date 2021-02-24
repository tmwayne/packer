#
# ------------------------------------------------------------------------------
# CentOS 8 Template for Packer
# ------------------------------------------------------------------------------
#
# Tyler Wayne © 2021
#

source "qemu" "centos8" {
  boot_command      = ["<tab> text ks=http:/{{ .HTTPIP }}:{{ .HTTPPort }}/centos8-ks.cfg<enter><wait>"]
  #disk_image        = "true"
  accelerator       = "kvm"
  boot_wait         = "10s"
  disk_interface    = "virtio"
  disk_size         = "5000M"
  display           = "none"
  format            = "raw" # either qcow2 or raw
  headless          = "true" # set to true to start without console
  http_directory    = "http"
  iso_checksum      = "none" # to save time during iterations
  iso_url           = "./isos/CentOS-8.3.2011-x86_64-dvd1.iso"
  memory            = "2048"
  net_device        = "virtio-net"
  output_directory  = "./images/centos8-test"
  #ssh_password      = "centoslook"
  ssh_private_key_file = "/home/tyler/.ssh/keys/centos"
  ssh_timeout       = "20m"
  ssh_username      = "tyler"
  vm_name           = "centos8-base.raw"
}

build {
  sources = ["source.qemu.centos8"]
  # provisioner "ansible" {
    # user            = "{build.user}" 
    # playbook_file   = "./playbook.yaml"
  # }
}

