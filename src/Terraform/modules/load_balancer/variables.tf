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


# ACM(Certification)

# modules/load_balancer/variables.tf

variable "domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

# variable "route53_zone_id" {
#   description = "The Route 53 Hosted Zone ID for DNS validation"
#   type        = string
# }

# variable "load_balancer_arn" {
#   description = "The ARN of the load balancer"
#   type        = string
#   default     = ""
# }

# variable "target_group_arn" {
#   description = "The ARN of the target group to forward traffic to"
#   type        = string
# }
