# VPC 정보 받아오기
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  
}

variable "private_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}




variable "ai_ami_id" {
  description = "The AMI ID for the AI server"
  type        = string
}

variable "ai_instance_type" {
  description = "The instance type for the AI server"
  type        = string
  # default     = "t3.medium"  # 필요에 따라 기본 인스턴스 타입 설정
}

variable "ai_key_name" {
  description = "The key pair name for the AI server"
  type        = string
}