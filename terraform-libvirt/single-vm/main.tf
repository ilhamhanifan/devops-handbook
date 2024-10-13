resource "null_resource" "check_user_group" {
  provisioner "local-exec" {
    command = "ls ~"
  }
}

resource "libvirt_volume" "ubuntu_noble" {
  name   = "ubuntu_noble"
  pool = "images"
  source = var.base_image
  format ="qcow2"
}

resource "libvirt_network" "vm_net" {
  name = "vm-net"
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


#Virtual Machines
data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
  vars = {
    hostname = var.hostname
    ip_address = cidrhost(var.base_ip, 10)
    pubkey = var.pubkey
    password = var.password
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "cloudinit.iso"
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_volume" "vm_disk" {
  name           = "vm-disk"
  size           = var.volume
  pool           = "volumes"
  base_volume_id = libvirt_volume.ubuntu_noble.id
}

resource "libvirt_domain" "vm" {
  name     = "vm"
  memory   = var.ram
  vcpu     = var.vcpu

  network_interface {
    network_id = libvirt_network.vm_net.id
    addresses = [cidrhost(var.base_ip , 10)]
  }

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }
  
  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

}

