# Create static inventory
locals {
  #ansible_ssh_private_key_file = "${path.cwd}${var.ssh_path}/${var.cluster_user}"
  environment = terraform.workspace
  groups = ["k8s-master", "k8s-worker"]
  #master_hosts = {
  #  for i in range(var.cluster_master_count) : 
  #  "${local.groups[0]}-${i+1}" => {
  #    group = [local.groups[0]]
  #    name = "${local.groups[0]}-${i+1}"
  #    hostname = "${local.groups[0]}-${i+1}.${var.domain_name}"
  #    ip = "${var.cluster_master_prefix_ip}${i+1}"
  #    gateway = var.cluster_gateway
  #    user = var.cluster_user
  #    vars = {
  #      apiserver_advertise_address = "${var.cluster_master_prefix_ip}${i+1}"
  #      k8s_pod_network_cidr = "10.10.0.0/16"
  #      k8s_pod_network_type = "calico"
  #      ansible_ssh_private_key_file = "${path.cwd}${var.ssh_path}/${var.cluster_user}"
  #    }
  #  }
  #}
  #worker_hosts = {
  #  for i in range(var.cluster_worker_count) : 
  #  "${local.groups[1]}-${i+1}" => {
  #    group = [local.groups[1]]
  #    name = "${local.groups[1]}-${i+1}"
  #    hostname = "${local.groups[1]}-${i+1}.${var.domain_name}"
  #    ip = "${var.cluster_worker_prefix_ip}${i+1}"
  #    gateway = var.cluster_gateway
  #    user = var.cluster_user
  #    vars = {
  #      ansible_ssh_private_key_file = "${path.cwd}${var.ssh_path}/${var.cluster_user}"
  #    }
  #  }
  #}
  #host_list = merge(local.master_hosts, local.worker_hosts)

  cluster_host = [ 
    for group, group_conf in var.k8s-cluster-init : { 
      for i in range(group_conf.count) : "${group_conf.prefix_name}${i + 1}" => { 
        gateway  = group_conf.gateway
        group    = [group]
        hostname = "${group_conf.prefix_name}${i + 1}.${group_conf.domain_name}"
        ip       = "${group_conf.prefix_ip}${i + 1}"
        name     = "${group_conf.prefix_name}${i + 1}"
        user     = group_conf.user
        vars     = merge(
          group_conf.vars.control_plane == true ? { "apiserver_advertise_address" = "${group_conf.prefix_ip}${i + 1}" } : {},
          {
            ansible_ssh_private_key_file = "${path.cwd}${var.ssh_path}/${group_conf.user}"
          },
          {
            for key, value in group_conf.vars : 
              key => value if value != null
          }
        )
      }
   }
  ] 
  cluster_host_map = merge([
    for group in local.cluster_host : {
      for key, value in group : key => value
    }
  ]...)
}


# Create dynamic inventory
module "ansible-host" {
  source = "./modules/ansible-host"
  cluster_user = var.cluster_user
  private_key = var.private_key
  host_list = local.cluster_host_map
}

# Create proxmox vm
module "proxmox-vm" {
  source = "./modules/proxmox-vm"
  host_list = local.cluster_host_map
  proxmox_host = var.proxmox_host
  pm_ssh_private_key = var.private_key
  depends_on = [
    module.ansible-host
  ]
}

# Run ansible playbooks
module "ansible-playbook" {
  source = "./modules/ansible-playbook"
  rewrite_host_list = module.ansible-host.rewrite_host_list
  ansible_playbooks_path = "${var.ansible_playbooks_path}"
  depends_on = [
    module.proxmox-vm
  ]
}

output "cluster_host" {
  value = local.cluster_host_map
}

output "group_list" {
  value = module.ansible-host.group_list
}

output "rewrite_host_list" {
  value = module.ansible-host.rewrite_host_list

}

output "rendered_inventory" {
  value = module.ansible-host.rendered_inventory
}

# Debug
output "current-workspace" {
  value = terraform.workspace
}

# output "inventory" {
#   value = {
#     group_list = distinct([for host in local.host_list : host.group])
#     name_list = [for host in local.host_list : host.name]
#     hostname_list = [for host in local.host_list : host.hostname]
#     ip_list = [for host in local.host_list : host.ip]
#     user = var.cluster_user
#     gateway = var.cluster_gateway
#   # value = local.inventory[*].name
#     # groups = local.inventory.host[*]
#     # name = local.inventory.
#   }
# }
