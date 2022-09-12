variable "subnet_ids"{
    type = list(string)
}
variable "vpc_id" {
  type = string
}
variable "cidr_block" {
  type = any
}
