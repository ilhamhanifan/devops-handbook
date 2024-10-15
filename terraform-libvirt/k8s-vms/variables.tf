variable "base_ip" {
  description = ""
  type = string
}

variable "master_ram" {
  description = ""
  type = string
}

variable "master_vcpu" {
  description = ""
  type = number
}

variable "worker_ram" {
  description = ""
  type = string
}

variable "worker_vcpu" {
  description = ""
  type = string
}

variable "lb_ram" {
  description = ""
  type = string
}

variable "lb_vcpu" {
  description = ""
  type = number
}

variable "volume" {
  description = ""
  type = string
}

variable "password" {
  description = ""
  type = string
}

variable "cloudinit" {
  description = ""
  type = string
}

variable "pubkey" {
  description = ""
  type = string
}

variable "base_image" {
  description = ""
  type = string
}

