variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the public subnets"
  type        = list(string)
}

variable "private_security_group_id" {
  description = "ID of the private security group"
  type       = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_indexes" {
  description = "EC2 instance index"
  type        = map(number)
}

variable "ami_ids" {
  description = "EC2 AMI ID"
  type        = map(string)
}

variable "ssh_keys" {
  description = "EC2 SSH access key name"
  type        = map(string)
}