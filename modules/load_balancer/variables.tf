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
}
