variable "region" {
  type    = string
  default = "us-east-1"
}
variable "keyname" {
  type    = string
  default = "luit-labs"
}
variable "ubuntu-ami" {
  type        = string
  default     = "ami-0866a3c8686eaeeba"
  description = "Latest Ubuntu AMI"
}
variable "linux-ami" {
  type        = string
  default     = "ami-012967cc5a8c9f891"
  description = "Latest Linux AMI"
}

variable "s3-bucket" {
  type    = string
  default = "jenkins2024-artifacts-bucket-luit"
}