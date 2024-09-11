variable "vpc_id" {
  description = "The ID of the VPC where the load balancer will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the load balancer"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the load balancer"
  type        = list(string)
  default = []
}

variable "domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

variable "anywhere_ip" {
  description = "IP address for anywhere"
  type        = string
}

variable "backend_id" {
  description = "ID of backend instance"
  type        = string
}