variable "vpc_cidr" {
  type    = string
  # default = "10.0.0.0/16"
}

variable "vpc_name" {
    type = string
    description = "vpc name"
  
}

variable "region" {
  type = string
}

variable "project" {
  type=string
}