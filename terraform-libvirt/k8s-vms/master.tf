data "template_file" "master_data" {
  count = 3
  template = file("${path.module}/user_data.tpl")
  vars = {
    hostname = "master-${count.index + 1}"
    ip_address = cidrhost(var.base_ip, count.index + 10)
    pubkey = var.pubkey
    password = var.password
  }
}

resource "libvirt_cloudinit_disk" "cloudinit_master" {
  count    = 3
  name     = "cloudinit-master${count.index + 1}.iso"
  user_data = data.template_file.master_data[count.index].rendered
}

resource "libvirt_domain" "master" {
  count    = 3
  name     = "master-${count.index + 1}"
  memory   = var.master_ram
  vcpu     = var.master_vcpu

  network_interface {
    network_id = libvirt_network.k8s_net.id
    addresses  = [cidrhost(var.base_ip, count.index + 10)]
  }

  disk {
    volume_id = libvirt_volume.ubuntu_noble.id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit_master[count.index].id
}

