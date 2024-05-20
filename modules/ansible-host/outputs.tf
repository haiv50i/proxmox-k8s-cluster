output "rewrite_host_list" {
  value = local.rewrite_host_list
}

output "rendered_inventory" {
  value = local.rendered_inventory
}

output "group_list" {
  value = local.group_list
}

output "dynamic-inventory" {
  value = resource.ansible_host.dynamic-inventory
}

output "private_key" {
  value = var.private_key
}
