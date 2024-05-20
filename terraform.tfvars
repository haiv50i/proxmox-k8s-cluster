
prefix = "proxmox"
proxmox_host = "prox"
k8s-cluster-init = {
  k8s-master = {
    count = 1,
    domain_name = "haiv.local",
    gateway = "192.168.10.1",
    prefix_name = "k8s-master-",
    prefix_ip = "192.168.10.2",
    user = "ubuntu",
    vars = {
        k8s_pod_network_cidr = "10.10.0.0/16", 
        k8s_pod_network_type = "calico"
        control_plane = true 
    }
  }
  k8s-worker = {
    count = 2,
    domain_name = "haiv.local",
    gateway = "192.168.10.1",
    prefix_name = "k8s-worker-",
    prefix_ip = "192.168.10.3",
    user = "ubuntu",
    vars = {}
  }

}

