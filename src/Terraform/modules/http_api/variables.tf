variable "api_name" {
  description = "Name of the HTTP API"
  type        = string
}

variable "backend_arn" {
  description = "ARN of the backend service"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for VPC Link"
  type        = string
}

variable "subnet_id" {
  description = "List of subnet IDs for VPC Link"
  type        = string
}

variable "api_routes" {
    description = "List of API routes and their configurations"
    type = map(object({
        route_key     = string
        method        = string
        uri           = string
        description   = string
    }))
}
