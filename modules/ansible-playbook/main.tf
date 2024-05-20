#create script add masters hosts

resource "null_resource" "create-rewrite-etc-hosts-script" {
  triggers = {
    host_ids = join(",", [for k, v in var.rewrite_host_list : k])
  }
  for_each = {
    for key, value in (var.rewrite_host_list) : key => value
  }
  provisioner "local-exec" {
    command = <<EOT
        echo "#!/bin/bash" > rewrite-etc-hosts.sh
      EOT
    working_dir = "${path.cwd}/plugins"
  }
  provisioner "local-exec" {
    command = <<EOT
      if ! grep -q "${each.value}" rewrite-etc-hosts.sh; then
        echo "if ! grep -q '"${each.value}"' /etc/hosts; then echo "${each.value}" >> /etc/hosts; fi" >> rewrite-etc-hosts.sh
      fi
      EOT
    working_dir = "${path.cwd}/plugins"
  }
}

resource "null_resource" "rewrite-etc-hosts" {
  triggers = {
    host_ids = join(",", [for k, v in var.rewrite_host_list : k])
  }
  provisioner "local-exec" {
    command = <<EOT
        sh ./rewrite-etc-hosts.sh
      EOT
    working_dir = "${path.cwd}/plugins"  
  }
  depends_on = [
      resource.null_resource.create-rewrite-etc-hosts-script,
  ]
}

resource "null_resource" "init-cluster" {
  triggers = {
    host_ids = join(",", [for k, v in var.rewrite_host_list : k])
  }
  depends_on = [
    resource.null_resource.rewrite-etc-hosts
  ]
  provisioner "local-exec" {
    command = <<EOT
        sleep 60
        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${path.cwd}${var.ansible_inventory_file}' main.yml
      EOT
    working_dir = "${path.cwd}${var.ansible_playbooks_path}"
  }
}

