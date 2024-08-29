variable "frontend_ami_id" {
  type = string
}

variable "frontend_instance_type" {
  type = string
}

variable "frontend_key_name" {
  type = string
}

variable "backend_ami" {
  type = string
}

variable "backend_instance_type" {
  type = string
}

variable "backend_private_ip" {
  type = string
}

variable "ai_ami_id" {
  type = string
}

variable "ai_instance_type" {
  type = string
}

variable "ai_key_name" {
  type = string
}

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
