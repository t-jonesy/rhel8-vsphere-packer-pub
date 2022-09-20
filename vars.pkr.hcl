variable "vsphere_server" {
  type    = string
  default = ""
}
variable "vsphere_user" {
  type    = string
  default = ""
}
variable "vsphere_password" {
  type    = string
  default = ""
}
variable "datacenter" {
  type    = string
  default = ""
}
variable "host" {
  type    = string
  default = ""
}
variable "datastore" {
  type    = string
  default = ""
}
variable "iso_name" {
  type    = string
  default = ""
}
variable "iso_sha256_checksum" {
  type    = string
  default = ""
}
variable "ssh_pass" {
  type    = string
  default = ""
}
variable "network_name" {
  type    = string
  default = ""
}
variable "rh_username" {
  type    = string
  default = ""
}
variable "rh_password" {
  type    = string
  default = ""
}
variable "build_username" {
  type    = string
  default = ""
}
variable "build_password_encrypted" {
  type    = string
  default = ""
}
variable "grub_pass" {
  type    = string
  default = ""
}
variable "grub_user" {
  type    = string
  default = ""
}
variable "local_users" {
  type    = string
  default = ""
}