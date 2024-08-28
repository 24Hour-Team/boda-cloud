variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
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

variable "instance_names" {
  description = "EC2 instance name"
  type        = list(string)
}

variable "ami_ids" {
  description = "EC2 AMI ID"
  type        = map(string)
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