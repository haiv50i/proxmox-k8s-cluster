terraform {
  required_providers {
    ansible = {
      source = "nbering/ansible"
      version = "1.0.4"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}
# just in case packer shell-local not create folder and ssh private key file
resource "null_resource" "create_ssh_folder" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
if [ ! -d "${path.cwd}/.ssh" ]; then
  mkdir "${path.cwd}/.ssh"
elif [ ! -f "${path.cwd}/.ssh/${var.cluster_user}" ]; then
  echo "${var.private_key}" > ${path.cwd}/.ssh/${var.cluster_user}
fi
EOT
  }
}

resource "ansible_host" "dynamic-inventory" {
  # count = var.ansible_master_count
  for_each = {
    for id, host in var.host_list : id => host
  }
  inventory_hostname = each.value.hostname
  groups = each.value.group
  vars = merge(
    {
      name = each.key
      host_ip = each.value.ip
      ansible_user = each.value.user
      gateway = each.value.gateway
    },
    can(each.value.vars) ? each.value.vars : {}
  )
    # ssh_private_key = sensitive("${var.private_key}")
}

locals {
  rewrite_host_list = [for host in (var.host_list) : "${host.ip} ${host.hostname} ${host.name}"]
  group_list = distinct(flatten([ for host in var.host_list : host.group]))
  rendered_inventory = templatefile("${path.cwd}/modules/ansible-host/inventory.tftpl", { group_list = local.group_list, host_list = var.host_list })
}

resource "null_resource" "rendered_inventory_file" {
  triggers = {
    inventory = "${md5(local.rendered_inventory)}"
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo '${local.rendered_inventory}' | sudo tee ${path.cwd}/modules/ansible-host/inventory.ini"
  }
}
