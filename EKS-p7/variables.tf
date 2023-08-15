
variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "cluster_name" {
  description = "EKS CLuster"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "private_subnets" {
  description = "Private Subnets"
}

variable "public_subnets" {
  description = "Public Subnets"
}

variable "node_group_1" {
  description = "EKS Node group 1"
}

variable "node_group_2" {
  description = "EKS Node group 2"
}

variable "instance_types" {
  description = "EC2 instance type"
}

variable "node_min_size" {
  description = "instance min_size"
  type        = number
}

variable "node_max_size" {
  description = "instance max_size"
  type        = number
}

variable "node_desired_size" {
  description = "node desired_size"
  type        = number
}

