#
# ------------------------------------------------------------------------------
# Variables Defintion File for CentOS 8 Image
# ------------------------------------------------------------------------------
#
# Tyler Wayne © 2021
#

variable "ssh_username" {
  type = string
  default = "tyler"
}

variable "ssh_private_key_file" {
  type = string
  default = "/home/tyler/.ssh/keys/centos"
}
