#cloud-config
hostname: ${hostname}
fqdn: ${hostname}.vm.local
timezone: Asia/Jakarta
manage_etc_hosts: true
network:
  version: 2
  ethernets:
    ens0:
      dhcp4: false
      addresses:
        - ${ip_address}/24
      gateway4: 10.0.0.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
users:
  - name: reisa
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    shell: /bin/bash
    lock_passwd: false
    ssh_authorized_keys: 
      - ${pubkey}
chpasswd:
  list: |
    reisa:${password}
  expire: False
