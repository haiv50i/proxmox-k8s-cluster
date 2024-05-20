terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "proxmox_vm_qemu" "k8s-cluster" {
  for_each = { for key,host in var.host_list : key => host }
  name = each.key
  desc = var.pm_description
  # this now reaches out to the vars file. I could've also used this var above in the pm_api_url setting but wanted to spell it out up there. target_node is different than api_url. target_node is which node hosts the template and thus also which node will host the new VM. it can be different than the host you use to communicate with the API. the variable contains the contents "prox-1u"
  target_node = var.proxmox_host

  # another variable with contents "ubuntu-2004-cloudinit-template"
  clone = var.pm_template_name

  # basic VM settings here. agent refers to guest agent
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  # bootdisk = "virtio0"
  qemu_os = "other"
  
  disks {
    virtio {
      virtio0 {
        disk {
          # set disk size here. leave it small for testing because expanding the disk takes time.
          size = 20
          storage = var.pm_storage_name
          iothread = false
        }
      }
    }
  }
  
  # if you want two NICs, just copy this whole network section and duplicate it
  network {
    model = "virtio"
    bridge = var.pm_nic_name
  }

  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  
  # the ${count.index + 1} thing appends text to the end of the ip address
  # in this case, since we are only adding a single VM, the IP will
  # be 10.98.1.91 since count.index starts at 0. this is how you can create
  # multiple VMs and have an IP assigned to each (.91, .92, .93, etc.)

  ipconfig0 = "ip=${each.value.ip}/24,gw=${each.value.gateway}"
  
  #ssh_user
  ssh_user = each.value.user

  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.pm_ssh_public_key}
  EOF

  cloudinit_cdrom_storage = "local-lvm"
  
  connection {
      type        = "ssh"
      user        = each.value.user
      private_key = var.pm_ssh_private_key
      host        = self.default_ipv4_address
    }

  provisioner "remote-exec" {
    inline = [
      "ip a",
      "sudo hostnamectl set-hostname ${each.key}",
      "while sudo lsof /var/lib/dpkg/lock-frontend ; do sleep 10; done;"
    ]
  }
}

