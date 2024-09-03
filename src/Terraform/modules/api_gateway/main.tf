#기본 API를 정의하는 리소스
resource "aws_api_gateway_rest_api" "boda_api" {
  name          = var.rest_api_name
  description   = "API Gateway for the application"
}


# API Gateway에서 경로를 정의하는 리소스
# 루트 리소스 /v1 생성
resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id = aws_api_gateway_rest_api.boda_api.root_resource_id
  path_part = "v1"
}


# /v1/user 경로의 부모 리소스를 생성
resource "aws_api_gateway_resource" "user" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "user"
}



# user 관련 경로를 위한 메서드 정의
resource "aws_api_gateway_method" "user_methods" {
  for_each = var.user_methods
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.user.id
  
  http_method   = each.value.method
                  
  authorization = "NONE"
}

# # /v1/user/get 리소스 생략, 바로 메서드 정의
# resource "aws_api_gateway_method" "user_get" {
#   rest_api_id = aws_api_gateway_rest_api.boda_api.id
#   resource_id = aws_api_gateway_resource.user.id
#   http_method = "GET"
#   authorization = "NONE"
# }

# # /v1/user/update 리소스 생략, 바로 메서드를 정의
# resource "aws_api_gateway_method" "user_update" {
#   rest_api_id = aws_api_gateway_rest_api.boda_api.id
#   resource_id = aws_api_gateway_resource.user.id
#   http_method = "PATCH"
#   authorization = "NONE"
# }

# # /v1/user/delete 리소스 생략, 바로 메서드를 정의
# resource "aws_api_gateway_method" "user_delete" {
#   rest_api_id = aws_api_gateway_rest_api.boda_api.id
#   resource_id = aws_api_gateway_resource.user.id
#   http_method = "DELETE"
#   authorization = "NONE"
# }



# 나머지 경로를 위한 리소스 정의
resource "aws_api_gateway_resource" "api_resources" {
  for_each   = var.api_paths
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = each.value.path
}

# API Gateway에서 HTTP 메서드를 정의하는 리소스(GET,POST,PUT,DELETE)
resource "aws_api_gateway_method" "api_methods" {
  for_each = var.api_methods
  rest_api_id = aws_api_gateway_rest_api.boda_api.id

  # resource_id = aws_api_gateway_resource.api_resources[each.key].id
  
  # user 경로는 별도로 처리
  resource_id = (
    each.key == "user/get" || each.key == "user/update" || each.key == "user/delete" ? aws_api_gateway_resource.user.id : aws_api_gateway_resource.api_resources[each.key].id
  )

  http_method = each.value.method
  authorization = "NONE"   #추후에 확인필요
}


# API Gateway에서 백엔드와의 통합을 정의하는 리소스
resource "aws_api_gateway_integration" "api_integration"{

  for_each = {
    for k, v in var.api_methods : k => v if !(k == "user/get" || k == "user/update" || k == "user/delete")
  }
  rest_api_id             = aws_api_gateway_rest_api.boda_api.id
  resource_id             = aws_api_gateway_resource.api_resources[each.key].id
  http_method             = aws_api_gateway_method.api_methods[each.key].http_method
  integration_http_method = each.value.method
  type                    = "HTTP"
  uri                     = each.value.uri

  # VPC Link(API Gateway to BackEnd)
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}

# API Gateway 배포 리소스
resource "aws_api_gateway_deployment" "boda_deployment" {
  depends_on  = [aws_api_gateway_method.api_methods]
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  stage_name  = var.stage_name
}

