This scipt will provison a single KVM Libvirt Virtual Machine

1. Before using the script run `./prescript.sh` as non-root user
2. create the file terraform.tfvars and fill it with the values:
```
hostname = "your-vm-hostname"
base_ip  = "your-vm-base-ip"
volume_size = "your-volume-size-in-bytes"
cloudinit = "your-cloudinit-file-path"
pubkey = "your-ssh-pubkey"
base_image_path = "your-base-image-path"
```
3. After that run `terraform apply`
4. virsh list --all; virsh console 0

# Notes
1. if the host have selinux or apparmor enabled there might be problems so just disable it by adding this option `secure_driver = none` in `/etc/libvirt/qemu.conf` 
2. please use absolute path for `base_image_path`. idk why relative path using `~` does not work.

# Resources
https://ubuntu.com/server/docs/libvirt
https://www.freeipa.org/page/Libvirt_with_VNC_Consoles
