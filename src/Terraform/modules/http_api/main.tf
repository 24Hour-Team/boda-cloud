# HTTP API 정의
resource "aws_apigatewayv2_api" "boda_api" {
  name          = var.api_name
  protocol_type = "HTTP"
  description   = "HTTP API gateway"
}

# 스테이지 정의
resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.boda_api.id
  name        = "$default"
  auto_deploy = true
}

# VPC Link 정의
resource "aws_apigatewayv2_vpc_link" "backend" {
  name               = "backend-vpc-link"
  security_group_ids = [var.security_group_id]
  subnet_ids         = [var.subnet_id]
}

# 통합 정의
resource "aws_apigatewayv2_integration" "backend_integration" {
  for_each           = var.api_routes
  api_id             = aws_apigatewayv2_api.boda_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = var.backend_arn
  integration_method = each.value.method
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.backend.id

  description = each.value.description
}

# 라우트 정의
resource "aws_apigatewayv2_route" "routes" {
  for_each  = var.api_routes
  api_id    = aws_apigatewayv2_api.boda_api.id
  route_key = each.value.route_key
  target    = "integrations/${aws_apigatewayv2_integration.backend_integration[each.key].id}"
}