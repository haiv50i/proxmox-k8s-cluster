# Ubuntu Server Focal
# ---
# Packer Template to create an Ubuntu Server (Focal) on Proxmox

# Variable Definitions
packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.7"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

locals {
  ssh_path  = "${path.cwd}/.ssh"
  
}
source "null" "check_ssh_private_key" {
  communicator = "none"
}


build {
  sources = ["source.null.check_ssh_private_key"]
  provisioner "shell-local" {
    inline = [
      "if [ ! -f '${local.ssh_path}/ubuntu' ]; then echo 'SSH private key not found'; fi ", 
    ]
  }
}

# Resource Definiation for the VM Template
source "proxmox-iso" "ubuntu-server-focal" {
 
    # Proxmox Connection Settings
    proxmox_url = "${var.api_url}"
    username = "${var.api_token_id}"
    token = "${var.api_token_secret}"
    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = true
    
    # VM General Settings
    node = "prox"
    vm_id = "1000"
    vm_name = "ubuntu-server-focal"
    template_description = "Ubuntu Server Focal Image"

    # VM OS Settings
    # (Option 1) Local ISO File
    # iso_file = var.iso_file
    # iso_checksum = var.iso_checksum
    iso_file = "local:iso/ubuntu-20.04.6-live-server-amd64.iso"
    iso_checksum = "b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"

    # - or -
    # (Option 2) Download ISO
    # iso_url = "https://releases.ubuntu.com/focal/ubuntu-20.04.6-live-server-amd64.iso"
    # iso_checksum = "b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"
    iso_storage_pool = "local"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "20G"
        format = "raw"
        storage_pool = "local-lvm"
    #storage_pool_type = "lvm"
        type = "virtio"
    }

    # VM CPU Settings
    cores = "2"
    
    # VM Memory Settings
    memory = "4096" 

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
        # vlan_tag = "100"
    } 

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"

    # PACKER Boot Commands
    boot_command = [
        "<esc><wait><esc><wait>",
        "<f6><wait><esc><wait>",
        "<bs><bs><bs><bs><bs>",
        "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
        "--- <enter>"
    ]
    boot = "c"
    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_directory = "http" 
    # (Optional) Bind IP Address and Port
    http_bind_address = "0.0.0.0"
    http_port_min = 8802
    http_port_max = 8802

    ssh_username = "ubuntu"

    # (Option 1) Add your Password here
    # ssh_password = "1"
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    ssh_private_key_file = "${local.ssh_path}/ubuntu"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {

    name = "ubuntu-server-focal"
    sources = ["source.proxmox-iso.ubuntu-server-focal"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }
    # provisioner "shell" {
    #   inline = [ "while sudo lsof /var/lib/dpkg/lock-frontend ; do sleep 10; done;"]
    # }
    # Add additional provisioning scripts here
    # ...
}
