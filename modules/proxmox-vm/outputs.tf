# output "k8s-master-info" {
#   value = {
#     master_count = length(resource.proxmox_vm_qemu.k8s-master[*])
#     master_name = resource.proxmox_vm_qemu.k8s-master[*].name
#     master_ip = resource.proxmox_vm_qemu.k8s-master[*].default_ipv4_address
#     pm_ssh_user = resource.proxmox_vm_qemu.k8s-master[*].ssh_user
#   }
# }


# output "k8s-worker-info" {
#   value = {
#     worker_count = length(resource.proxmox_vm_qemu.k8s-worker[*])
#     worker_name = resource.proxmox_vm_qemu.k8s-worker[*].name
#     worker_ip = resource.proxmox_vm_qemu.k8s-worker[*].default_ipv4_address
#     pm_ssh_user = resource.proxmox_vm_qemu.k8s-worker[*].ssh_user
#   }
# }

# output "k8s-master" {
#   value = resource.proxmox_vm_qemu.k8s-master[*]
# }


# output "k8s-worker" {
#   value = resource.proxmox_vm_qemu.k8s-worker[*]
# }