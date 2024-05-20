# Variables for nbering/dynamic-inventory
variable "ansible_tf_bin" {
  default = "/usr/bin/terraform"
}

variable "ansible_tf_dir" {
  default = "/data/demo"
}

variable "private_key" {
  type = string
  sensitive = true
}

variable "host_list" {
  type = any
}

variable "cluster_user" {
  type = string
}

variable "inventory" {
  type = any
  default = []
}
