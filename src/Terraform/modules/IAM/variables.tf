variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile"
  type        = string
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs to grant access to"
  type        = string
}