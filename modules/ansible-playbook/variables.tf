variable "ansible_playbooks_path" {
  type = string
  default = "/ansible_playbooks"
}

# Static inventory file path
variable "ansible_inventory_file" {
  type = string
  default = "/modules/ansible-host/inventory.ini"
}

# Dynamic inventory file path 
variable "ansible_inventory_plugin_file" {
  type = string
  default = "/plugins/terraform.py"
}

variable "rewrite_host_list" {
  type = any
}
