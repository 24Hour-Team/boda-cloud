resource "aws_iam_role" "boda_ec2_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "boda_s3_access" {
  name = "BODA_S3_Access_Policy"
  role = aws_iam_role.boda_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = var.s3_bucket_arns
      }
    ]
  })
}

resource "aws_iam_instance_profile" "boda_ec2_instance_profile" {
  name = var.iam_instance_profile_name
  role = aws_iam_role.boda_ec2_role.name
}