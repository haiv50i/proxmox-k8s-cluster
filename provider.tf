# provider "proxmox" {
#   pm_api_url = "https://proxmox.mydomain.intra:8006/api2/json"
#   # api token id is in the form of: <username>@pam!<tokenId>
#   pm_api_token_id = "tfuser@pve!terraform"
#   # this is the full secret wrapped in quotes.
#   pm_api_token_secret = var.PROXMOX_API_SECRET
#   pm_tls_insecure     = true

#   # debug log
#   #  pm_log_enable = true
#   #  pm_log_file   = "terraform-plugin-proxmox.log"
#   #  pm_debug      = true
#   #  pm_log_levels = {
#   #    _default    = "debug"
#   #    _capturelog = ""
#   #  }
# }

#using terraform cloud with workspace named: proxmox and only run on local(Execution mode: Local) 
#terraform cloud using for storing terraform state only
terraform {
  cloud {
    organization = "hajv5" 
    hostname = "app.terraform.io"
    workspaces { 
      # name = "proxmox-dev"
      tags = ["proxmox"] 
    } 
  }
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
    local = {
      source = "hashicorp/local"
    }
    ansible = {
      source = "nbering/ansible"
      version = "1.0.4"
    }
  }
}
provider "proxmox" {
  # url is the hostname (FQDN if you have one) for the proxmox host you'd like to connect to to issue the commands. my proxmox host is 'prox-1u'. Add /api2/json at the end for the API
  pm_api_url = var.api_url

  # api token id is in the form of: <username>@pam!<tokenId>
  pm_api_token_id = var.api_token_id

  # this is the full secret wrapped in quotes. don't worry, I've already deleted this from my proxmox cluster by the time you read this post
  pm_api_token_secret = var.api_token_secret

  # leave tls_insecure set to true unless you have your proxmox SSL certificate situation fully sorted out (if you do, you will know)
  pm_tls_insecure = true
}
