output "cluster_host" {
  value = local.cluster_host_map
}

output "group_list" {
  value = module.ansible-host.group_list
}

output "rewrite_host_list" {
  value = module.ansible-host.rewrite_host_list
}

output "private_ips" {
  value =  module.proxmox-vm.private_ips 
}

output "rendered_inventory" {
  value = module.ansible-host.rendered_inventory
  sensitive = true
}

# Debug
output "current-workspace" {
  value = terraform.workspace
}
