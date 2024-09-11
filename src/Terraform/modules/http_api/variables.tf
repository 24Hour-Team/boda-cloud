variable "api_name" {
  description = "Name of the HTTP API"
  type        = string
}

variable "backend_url" {
  description = "URL of the backend service"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for VPC Link"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for VPC Link"
  type        = list(string)
}

variable "routes" {
  description = "Map of routes to create"
  type = map(object({
    method = string
    path   = string
  }))
}