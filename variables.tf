variable "region" {
  type    = string
  default = "us-east-1"
}
variable "keyname" {
  type    = string
  default = "luit-labs"
}
variable "defualt-vpc" {
  type    = string
  default = "172.31.0.0/16"
}
variable "ubuntu-ami" {
  type    = string
  default = "ami-0866a3c8686eaeeba"
}
