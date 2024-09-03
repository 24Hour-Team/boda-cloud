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

#####################
### 경로별 리소스 & 메서드
#####################

# /v1/user 경로의 부모 리소스(= /user)를 생성
resource "aws_api_gateway_resource" "user" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "user"
}

# user 관련 메서드 정의
resource "aws_api_gateway_method" "user_methods" {
  for_each = var.user_methods
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.user.id
  http_method   = each.value.method   
  authorization = "NONE"
}



# /v1/bookmark 경로의 부모 리소스(= /bookmark, /bookmark/folder) 생성

# /v1/bookmark 경로 생성
resource "aws_api_gateway_resource" "bookmark" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "bookmark"
}

# /v1/bookmark/folder 경로 생성
resource "aws_api_gateway_resource" "bookmark_folder" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.bookmark.id
  path_part   = "folder"
}

###
# /v1/bookmark/folder 메서드 정의
resource "aws_api_gateway_method" "bookmark_folder_post" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.bookmark_folder.id
  http_method = "POST"
  authorization = "NONE"
}



# /v1/bookmark/folder 관련 리소스 정의 (/bookmark/folder/etc..)
resource "aws_api_gateway_resource" "bookmark_folder_resources" {
  for_each   = var.bookmark_folder_paths
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.bookmark_folder.id
  path_part   = each.value.path
}

# /v1/bookmark/folder 관련 메서드 정의
resource "aws_api_gateway_method" "bookmark_folder_methods" {
  for_each = var.bookmark_folder_methods
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.bookmark_folder_resources[each.key].id
  http_method = each.value.method
  authorization = "NONE"
}




# /v1/bookmark 관련 리소스 정의  (/v1/bookmark/etc..)
resource "aws_api_gateway_resource" "bookmark_resources" {
  for_each   = var.bookmark_paths
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.bookmark.id
  path_part   = each.value.path
}

# /v1/bookmark 관련 메서드 정의
resource "aws_api_gateway_method" "bookmark_methods" {
  for_each = var.bookmark_methods
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.bookmark_resources[each.key].id
  http_method = each.value.method
  authorization = "NONE"
}


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
  
  # user 경로는 별도로 처리
  resource_id = (
    each.key == "user/get" || each.key == "user/update" || each.key == "user/delete" ? aws_api_gateway_resource.user.id : aws_api_gateway_resource.api_resources[each.key].id
  )

  http_method = each.value.method
  authorization = "NONE"   #추후에 확인필요
}





#################
## Integration
#################



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




# /v1/user 경로에 대한 통합 정의
resource "aws_api_gateway_integration" "user_integration" {
  for_each = var.user_methods
  rest_api_id             = aws_api_gateway_rest_api.boda_api.id
  resource_id             = aws_api_gateway_resource.user.id
  http_method             = aws_api_gateway_method.user_methods[each.key].http_method
  integration_http_method = each.value.method
  type                    = "HTTP"
  uri                     = each.value.uri
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}


# bookmark_folder 경로에 대한 통합 정의
resource "aws_api_gateway_integration" "bookmark_folder_integration" {
  for_each = var.bookmark_folder_methods
  rest_api_id             = aws_api_gateway_rest_api.boda_api.id
  resource_id             = aws_api_gateway_resource.bookmark_folder_resources[each.key].id
  http_method             = aws_api_gateway_method.bookmark_folder_methods[each.key].http_method
  integration_http_method = each.value.method
  type                    = "HTTP"
  uri                     = each.value.uri
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}


# bookmark 경로에 대한 통합 정의
resource "aws_api_gateway_integration" "bookmark_integration" {
  for_each = var.bookmark_methods
  rest_api_id             = aws_api_gateway_rest_api.boda_api.id
  resource_id             = aws_api_gateway_resource.bookmark_resources[each.key].id
  http_method             = aws_api_gateway_method.bookmark_methods[each.key].http_method
  integration_http_method = each.value.method
  type                    = "HTTP"
  uri                     = each.value.uri
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}




# API Gateway 배포 리소스
resource "aws_api_gateway_deployment" "boda_deployment" {
  depends_on  = [aws_api_gateway_method.api_methods]
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  stage_name  = var.stage_name
}

