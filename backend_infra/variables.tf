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




# EC2 인스턴스 설정
variable "backend_ami" {
  description   = "The AMI ID for the backend server"
  type          = string
}

variable "backend_instance_type" {
  description   = "The instance type for the backend server"
  type          = string
  # default       = "t3.medium"    # 필요에 따라 기본 인스턴스 타입 설정
}

variable "backend_private_ip" {
    description = "The private IP address to assign to the backend server"
    type        = string
    #default     = "10.0.48.10"   # 추후에 원하는 IP로 변경
}

