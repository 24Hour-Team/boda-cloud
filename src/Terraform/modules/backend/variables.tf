variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the public subnets"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_indexes" {
  description = "EC2 instance index"
  type        = map(number)
}

variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
}

variable "ssh_keys" {
  description = "EC2 SSH access key name"
  type        = map(string)
}

variable "elastic_ips" {
  description = "Elastic IPs for public subnets"
  type        = map(string)
}

variable "private_ips" {
  description = "Private IPs for subnets"
  type        = map(string)
}

variable "anywhere_ip" {
  description = "IP address for anywhere"
  type        = string
}