variable "env" {
  description = "Environment name."
  type        = string
}
variable "node_iam_role"{
  type = string
}
variable "eks_cluster_role"{
type = string
}
variable "eks_cluster_autoscaler_role"{
  type = string
}
variable "eks_cluster_autoscaler_policy"{
  type = string
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "vpc_cidr_block" {
  description = "CIDR (Classless Inter-Domain Routing)."
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR ranges for private subnets."
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR ranges for public subnets."
  type        = list(string)
}

variable "aws_region"{
  type = string
}
variable "node_instance_type" {
  type = string
}
variable "min_number_of_nodes" {
  type = number
}
variable "max_number_of_nodes" {
  type = number
}
variable "desired_number_of_nodes" {
  type = number
}

variable "cluster_name" {
  default = "demo"
  type = string
  description = "AWS EKS CLuster Name"
  nullable = false
}
