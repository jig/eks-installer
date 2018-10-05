#
# Variables Configuration
#

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}

variable "cluster-size" {
  default = "1"
  type    = "string"
}

variable "cluster-region" {
  default = "eu-west-1"
  type    = "string"
}

variable "cluster-instance-type" {
  default = "m3.medium"
  type    = "string"
}

variable "cluster-key-name" {
  default = ""
  type    = "string"
}
