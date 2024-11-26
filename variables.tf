variable "prefix" {
  default = "likz"
}

variable "boundary_version" {
  default = "0.17.0+ent"
}

variable "region" {
  default = "Southeast Asia"
}

variable "network_address_space" {
  default = ["10.0.0.0/16"]
}

variable "network_public_subnet" {
  default = ["10.0.1.0/24"]
}

variable "network_private_subnet" {
  default = ["10.0.2.0/24"]
}

variable "controller_count" {
  default = 1
}

variable "vm_username" {
  type    = string
  default = "adminuser"
}

variable "vm_password" {
  type    = string
  default = "Password1234!"
}
