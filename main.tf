# Create static inventory
locals {
  environment = terraform.workspace
  groups = ["k8s-master", "k8s-worker"]
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
  ansible_playbooks_path = var.ansible_playbooks_path
  depends_on = [
    module.proxmox-vm
  ]
}
