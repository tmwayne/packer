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
  ssh_host = "192.168.122.20"
  ssh_password = "centoslook"
  ssh_username = "root"
  vm_name = "centos7-base.qcow2"
  disk_size = "5000M"
  memory = "2048"
}

# Source -----------------------------------------------------------------------

source "qemu" "centos" {
  boot_command      = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${local.preseed_file}<enter><wait>"]
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

source "null" "centos" {
  ssh_host = local.ssh_host
  ssh_username = local.ssh_username
  ssh_password = local.ssh_password
}

# Build Images -----------------------------------------------------------------

build {
  sources = ["source.qemu.centos"]
  provisioner "file" {
    source = "http/sudoers.tyler"
    destination = "/tmp/sudoers.tyler"
  }
  provisioner "file" {
    source = "http/centos.pub"
    destination = "/tmp/key.pub"
  }
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} {{ .Path }} > /tmp/output.txt 2>&1"
    inline = [
      # add admin user to sudoers
      # "curl -s -o /etc/sudoers.d/tyler ${build.PackerHTTPAddr}/sudoers.tyler",
      "mv /tmp/sudoers.tyler /etc/sudoers.d/tyler",
      "chmod 0440 /etc/sudoers.d/tyler",

      # setup public key authentication
      "mkdir -m 0700 /home/tyler/.ssh",
      # "curl -s -o /home/tyler/.ssh/authorized_keys ${build.PackerHTTPAddr}/centos.pub",
      "mv /tmp/key.pub /home/tyler/.ssh/authorized_keys",
      "chmod 0600 /home/tyler/.ssh/authorized_keys",
      "chown -R tyler:tyler /home/tyler/.ssh",

      # disable reverse DNS and harden sshd
      # sed --in-place='.bk' -e '/UseDNS/d' -e '/PasswordAuthentication/d' /etc/ssh/sshd_config",
      # echo 'UseDNS no' >> /etc/ssh/sshd_config",
      # echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config",

      # cleanup
      # "rm -f /etc/udev/rules.d/70-persistent-net.rules",
      # "rm -f /var/lib/dhclient/dhclient-eth0.leases",
      # "rm -rf /tmp/*",
      # "yum -y clean all"
    ]
    skip_clean = true
  }
  # post-processor "vagrant" {
    # keep_input_artifact = true
    # output = "/home/tyler/data/boxes/centos/7/centos7-base.box"
    # provider_override = "libvirt"
# # TODO: figure out how to vagrantfile template to work
    # vagrantfile_template = "./vagrantfile.template"
  # }

}
