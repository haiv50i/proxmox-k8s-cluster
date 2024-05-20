# provider proxmox variables
variable "api_token_id" {
  description = "Proxmox api token id"
}

variable "api_token_secret" {
  description = "Proxmox api token secret"
}

variable "api_url" {
  description = "Proxmox api url"
  default = "https://192.168.10.5:8006/api2/json/"
}

variable "prefix" {
  type = string
}

variable "ssh_path" {
  default = "/.ssh"
}

variable "private_key" {
  description = "Get from TF_VAR environment variable"
  sensitive = true
}

variable "public_key" {
  description = "Get from TF_VAR environment variable"
  sensitive = true
}
# Environment
variable "environment" {
  type = string
  default = "dev"
}
#
## k8s cluster variables
#variable "domain_name" {
#  type = string
#}
#
#variable "cluster_master_count" {
#  type = number
#  default = 1
#}
#
#variable "cluster_worker_count" {
#  type = number
#  default = 2
#}
#
#variable "cluster_gateway" {
#  type = string
#  default = "192.168.10.1"
#}
#
#variable "cluster_master_prefix_ip" {
#  type = string
#  default = "192.168.10.2"
#}
#
#variable "cluster_worker_prefix_ip" {
#  type = string
#  default = "192.168.10.3"
#}
#
#variable "cluster_master_prefix_name" {
#  default = "k8s-master-"
#}
#
#variable "cluster_worker_prefix_name" {
#  default = "k8s-worker-"
#}
# Default user for ssh connection
variable "cluster_user" {
  type = string
  default = "ubuntu"
}

# ansible variables
variable "ansible_playbooks_path" {
  type = string
  default = "/ansible_playbooks"
}

variable "ansible_plugins_path" {
  type = string
  default = "/plugins"
}

variable "dynamic_inventory_plugin_file" {
  default = "/plugins/terraform.py"
}


variable "proxmox_host" {
  type = string
}

#init cluster
variable "k8s-cluster-init" {
  description = "List of hosts with their configuration details"
  type = map(object({
    count = number
    user = string
    gateway = string
    domain_name = string
    prefix_name = string
    prefix_ip = string
    vars = optional(object({
      apiserver_advertise_address = optional(string)
      k8s_pod_network_cidr = optional(string)
      k8s_pod_network_type = optional(string)
      ansible_ssh_private_key_file = optional(string)
      control_plane = optional(bool) 
    }))
  }))
}


