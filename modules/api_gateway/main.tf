#기본 API를 정의하는 리소스
resource "aws_api_gateway_rest_api" "example_api" {
  name          = var.rest_api_name
  description   = "API Gateway for the application"
}


# API Gateway에서 경로를 정의하는 리소스
# 루트 리소스
resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part = "v1"
}

resource "aws_api_gateway_resource" "api_resource" {
  for_each = var.api_paths
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id = aws_api_gateway_resource.v1.id
  path_part = each.value.path
}

# API Gateway에서 HTTP 메서드를 정의하는 리소스(GET,POST,PUT,DELETE)
resource "aws_api_gateway_method" "api_methods" {
  for_each = var.api_methods
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.api_resource[each.key].id
  http_method = each.value.method
  authorization = "NONE"   #추후에 확인필요
}

resource "aws_api_gateway_integration" "api_integration"{
  for_each                = var.api_methods
  rest_api_id             = aws_api_gateway_rest_api.example_api.id
  resource_id             = aws_api_gateway_resource.api_resources[each.key].id
  http_method             = aws_api_gateway_method.api_methods[each.key].http_method
  integration_http_method = each.value.method
  type                    = "HTTP"
  uri                     = each.value.url

  # VPC Link(API Gateway to BackEnd)
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}


resource "aws_api_gateway_deployment" "example_deployment" {
  depends_on  = [aws_api_gateway_method.api_methods]
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  stage_name  = var.stage_name
}

