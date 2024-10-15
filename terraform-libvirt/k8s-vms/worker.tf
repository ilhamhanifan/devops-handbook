data "template_file" "worker_data" {
  count = 3
  template = file("${path.module}/user_data.tpl")
  vars = {
    hostname = "worker-${count.index + 1}"
    ip_address = cidrhost(var.base_ip, count.index + 20)
    pubkey = var.pubkey
    password = var.password
  }
}

resource "libvirt_cloudinit_disk" "cloudinit_worker" {
  count    = 3
  name     = "cloudinit-worker${count.index + 1}.iso"
  user_data = data.template_file.worker_data[count.index].rendered
}


resource "libvirt_domain" "worker" {
  count    = 3
  name     = "worker-${count.index + 1}"
  memory   = var.worker_ram
  vcpu     = var.worker_vcpu

  network_interface {
    network_id = libvirt_network.k8s_net.id
    addresses  = [cidrhost(var.base_ip, count.index + 20)]
  }

  disk {
    volume_id = libvirt_volume.ubuntu_noble.id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit_worker[count.index].id

}

