# IAM 유저 생성

resource "aws_iam_user" "devloper1" {
    name = "devloper1"
    path = "/system/"
}

# 사용자 그룹 생성

resource "aws_iam_group" "developer_group" {
    name = "developer"
    path = "/system/"
}


# 사용자와 그룹 연결

resource "aws_iam_group_membership" "developer_membership" {
  name = "developer_membership"

  users = [
    aws_iam_user.devloper1.name,
  ]

  group = aws_iam_group.developer_group.name
}


# 정책 추가 및 연결

resource "aws_iam_policy" "developer_policy" {
  name        = "developer_policy"
  path        = "/system/"
  description = "developer policy"
  #   policy      = file("developer_policy.json")

  # Heredoc syntax
  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Action": [
        "s3:ListAllMyBuckets"
    ],
    "Effect": "Allow",
    "Resource": "*"
    }
]
}
EOF
}