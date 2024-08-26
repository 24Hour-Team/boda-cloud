// IAM 변수
variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile"
  type        = string
}

variable "s3_bucket_arns" {
  description = "The S3 bucket ARN"
  type        = string
}

// 네트워크 변수
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for the database subnets"
  type        = list(string)
}

variable "elastic_ips" {
  description = "Elastic IPs for public subnets"
  type        = map(string)
}

// 인스턴스 변수
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_names" {
  description = "EC2 instance name"
  type        = list(string)
}

variable "instance_indexes" {
  description = "EC2 instance index"
  type        = map(number)
}

variable "ami_ids" {
  description = "EC2 AMI ID"
  type        = map(string)
}

variable "ssh_keys" {
  description = "EC2 SSH access key name"
  type        = map(string)
}

// 데이터베이스 변수
variable identifier {
  description = "RDS instance name"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "Database instance type"
  type        = string
}

variable "allocated_storage" {
  description = "Database allocated storage"
  type        = number
}

variable "storage_type" {
  description = "Database storage type"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}
