variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "elastic_ips" {
  description = "Elastic IPs for public subnets"
  type        = map(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_names" {
  description = "EC2 instance name"
  type        = list(string)
}

variable "instance_indexes" {
  description = "EC2 instance index"
  type        = map(number)
}
