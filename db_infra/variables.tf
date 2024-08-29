
# RDS 설정
variable "db_allocated_storage" {
  description = "The allocated storage for the database (in GB)"
  type        = number
}

variable "db_engine" {
  description = "The database engine"
  type        = string
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
}

variable "db_instance_class" {
  description = "The instance class for the database"
  type        = string
}


# 계정

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "The username for the MySQL database"
  type        = string
}

variable "db_password" {
  description = "The password for the MySQL database"
  type        = string
}





# variable "db_instance_class" {
#   description = "The instance type for the MySQL database instance"
#   type        = string
#   default     = "db.t3.micro"
# }

# variable "db_allocated_storage" {
#   description = "The allocated storage size for the MySQL database (in GB)"
#   type        = number
#   default     = 20
# }
