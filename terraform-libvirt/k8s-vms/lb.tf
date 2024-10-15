data "template_file" "lb_data" {
  count = 3
  template = file("${path.module}/user_data.tpl")
  vars = {
    hostname = "lb-${count.index + 1}"
    ip_address = cidrhost(var.base_ip, count.index + 30)
    pubkey = var.pubkey
    password = var.password
  }
}

resource "libvirt_cloudinit_disk" "lb_cloudinit" {
  count    = 2
  name     = "cloudinit-lb${count.index + 1}.iso"
  user_data = data.template_file.lb_data[count.index].rendered
}

resource "libvirt_domain" "load_balancer" {
  count    = 2
  name     = "lb-${count.index + 1}"
  memory   = var.lb_ram
  vcpu     = var.lb_vcpu

  network_interface {
    network_id = libvirt_network.k8s_net.id
    addresses  = [cidrhost(var.base_ip, count.index + 30)]
  }

  disk {
    volume_id = libvirt_volume.ubuntu_noble.id
  }

  cloudinit = libvirt_cloudinit_disk.lb_cloudinit[count.index].id
}
