variable "region" {
  type    = string
  default = "us-east-1"
}
# locals {

#   az1 = "${var.region}a"
#   az2 = "${var.region}b"
#   az3 = "${var.region}c"

# }
variable "vpc_name" {
  type        = string
  description = "vpc name"
  default     = "WeTravel_Task"

}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_subnets_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnets_cidr" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
# variable "subnet_ids" {
#   type    = list(string)
#   default = ["us12ddd", "djssjkddsf"]
# }
# variable "vpc_id" {
#   type    = string
#   default = ""
# }
# variable "cidr_block" {
#   type    = any
#   default = "testing"
# }
# variable "eks_subnet_ids" {
#   type    = list(string)
#   default = ["asa", "asa", "asad", "des"]
# }
# variable "eks_node_subnets_ids" {
#   type    = list(string)
#   default = ["add"]
# }
# variable "secret_key" {
#   type = string

# }
# variable "access_key" {
#   type = string

# }
