# Terraform Module이 VPC와 Subnet을 생성할 수 있도록, 필요한 인프라 정보를 외부에서 주입받을 수 있도록 variable을 정의

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "public_subnets_cidr" {
  description = "The CIDR blocks for the public subnet"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "The CIDR blocks for the private subnet"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to deploy to"
  type        = list(string)
}


variable "frontend_elastic_ip" {
  description = "elastic IP for FrontEnd"
  type        = string
}

variable "nat_elastic_ip" {
  description = "elastic IP for NAT Gateway"
  type        = string
}