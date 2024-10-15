resource "libvirt_volume" "ubuntu_noble" {
  name   = "ubuntu_noble"
  pool = "images"
  source = var.base_image
  format ="qcow2"
}

resource "libvirt_network" "k8s_net" {
  name = "k8s-net"
  mode = "nat"
  domain = "vm.local"
  addresses = [var.base_ip]

  dns {
    enabled = true
    local_only = true
  }
  
  dhcp {
    enabled = false
  }
}

