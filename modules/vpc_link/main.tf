resource "aws_api_gateway_vpc_link" "example_vpc_link" {
  name = "example-vpc-link"
  target_arns = [var.load_balancer_arn]  # Network Load Balancer ARN(최신 버전은 리스트로 받아야 함)
}

output "vpc_link_id" {
  value = aws_api_gateway_vpc_link.example_vpc_link.id
}
