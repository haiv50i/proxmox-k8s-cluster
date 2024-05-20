#Establish which Proxmox host you'd like to spin a VM up on
variable "proxmox_host" {
  type = string
}

variable "host_list" {
  type = any
}

# Basic vm config
variable "pm_description" {
  type = string
  default = "Created by Terraform"
}

# Specify which template name you'd like to use
variable "pm_template_name" {
  type = string
  default = "ubuntu-server-focal"
}

variable "pm_storage_name" {
  type = string
  default = "local-lvm"
}

# Establish which nic you would like to utilize
variable "pm_nic_name" {
  type = string
  default = "vmbr0"
}

# Establish the VLAN you'd like to use
# variable "vlan_num" {
#     default = "vlan_number"
# }

# Set your public SSH key here
variable "pm_iso_file" {
  type = string
  default = "local:iso/ubuntu-20.04.6-live-server-amd64.iso"
}

variable "pm_iso_checksum" {
  type = string
  default = "b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"
}

variable "pm_ssh_private_key" {
  type = string
  sensitive = true
  # default = ""
}

variable "pm_ssh_public_key" {
  type = string
  sensitive = true
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDoyu5NSBKfAsDUf9Ah9845mOscDZqSzoT1fgJcI62kCq4dS0UzzKvWkfpU8njG1C4ULAQLkGbYMJQJBSVlFYsYfPxt6vt2as0Y+kEzE+q8sP04JP7WnxGogVZV0C+qWs90qtJMmwy2xSXxJgXjZ3+46rV+9lqT4bF4BvolEx37Wu5ejn9Fbo8aomv3R5UCRiSclYhp0Gt2Q+Fm3oeu4PMvfHkdAkM8Juh+HsJQV5EWfw4SbGY7ppxgTOOsSwMxErxyursRKFmmtXYMdCNubKaQGYdLv6ReI5oJnu0Vs06en07HDJqL28RSXKgiF2ttdBv9JOm+HmWPSdhc3M9MgUeOi8ueAkRxruxbjbk0pwF4ycnLjnIS7abp/ScwcyjP+NhbmsAAjlblDPIp2+ncsAlwnUSP15r1TOFBRhoh8CMPJ8mwoblpD0+3ijrNk3q0owdEFokgIsvdSOjnjlyvKUhUY8gddVHC9zRu5EwjHXJG+KUw0fde1jXqge4tmixyGJ41JrHvheFUzJ6CYWzzjTvlyhFaPfWstdYeAHIcMzPdjmmNzv5LZggWP5iUwmMYcGa5DOLP+b3BHXvYvK9mNAoHO62YD8axdgpluWXs47ziJxZkG15TWkoqUqJblNQ6sU8h4y+uiDHuly2vHUwcNg68xzXmVZOxB5DaHOj9RElqMQ== haiv5@haiv5x1"
}
