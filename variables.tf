# VPC Variable

variable "aws_region" {
  description = "The AWS region where resources will be created"
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
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to use for the subnets"
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



# Front Variable

variable "frontend_ami_id" {
  type = string
}

variable "frontend_instance_type" {
  type = string
}

variable "frontend_key_name" {
  type = string
}


#BackEnd Variable

variable "backend_ami" {
  type = string
}

variable "backend_instance_type" {
  type = string
}

variable "backend_private_ip" {
  type = string
}

#AI Variable

variable "ai_ami_id" {
  type = string
}

variable "ai_instance_type" {
  type = string
}

variable "ai_key_name" {
  type = string
}

# DB Variable
variable "db_allocated_storage" {
  type = number
}

variable "db_engine" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}
