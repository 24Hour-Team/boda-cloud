variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}




variable "frontend_ami_id" {
  description = "The AMI ID for the frontend server"
  type        = string
}

variable "frontend_instance_type" {
  description = "The instance type for the frontend server"
  type        = string
  default     = "t3.micro"  # 필요에 따라 기본 인스턴스 타입 설정
}

variable "frontend_key_name" {
  description = "The key pair name for the frontend server"
  type        = string
}


