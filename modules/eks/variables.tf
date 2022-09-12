variable "eks_subnet_ids" {
  type=list(string)
}
variable "eks_node_subnets_ids" {
  type=list(string)
  
}
variable "vpc_id" {
  type = string
}