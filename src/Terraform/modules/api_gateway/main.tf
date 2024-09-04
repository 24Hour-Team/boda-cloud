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


############

# /v1/bookmark/{bookmarkFolderId} 경로 생성
resource "aws_api_gateway_resource" "bookmark_list" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.bookmark.id
  path_part   = "{bookmarkFolderId}"
}

# /v1/bookmark/{bookmarkFolderId}에 대한 GET 메서드 정의
resource "aws_api_gateway_method" "bookmark_list_method" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.bookmark_list.id
  http_method = "GET"
  authorization = "NONE"
}


# /v1/bookmark/{bookmarkId} 경로 생성
resource "aws_api_gateway_resource" "bookmark_delete" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.bookmark.id
  path_part   = "{bookmarkId}"
}


# /v1/bookmark/{bookmarkId}에 대한 DELETE 메서드 정의
resource "aws_api_gateway_method" "bookmark_delete_method" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.bookmark_delete.id
  http_method = "DELETE"
  authorization = "NONE"
}


# /v1/bookmark/{bookmarkFolderId}/{spotId} 경로 별도 생성
resource "aws_api_gateway_resource" "bookmark_create" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.bookmark_list.id
  path_part   = "{spotId}"
}

# /v1/bookmark/{bookmarkFolderId}/{spotId}에 대한 GET 메서드 정의
resource "aws_api_gateway_method" "bookmark_create_method" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.bookmark_create.id
  http_method = "GET"
  authorization = "NONE"
}






#######################################################

# /v1/spot 경로 생성
resource "aws_api_gateway_resource" "spot" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "spot"
}

# /v1/spot/{spotId} 경로 생성
resource "aws_api_gateway_resource" "spot_get" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  parent_id   = aws_api_gateway_resource.spot.id
  path_part   = "{spotId}"
}

# /v1/spot/{spotId} 관련 GET 메서드 정의
resource "aws_api_gateway_method" "spot_get_methods" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.spot_get.id  # spot/get 메서드에 대해
  http_method = "GET"
  authorization = "NONE"
}

# /v1/spot/쿼리 파라미터에 대한 GET 메서드 정의
resource "aws_api_gateway_method" "spot_search_method" {
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  resource_id = aws_api_gateway_resource.spot.id  # 부모 경로에 메서드를 추가
  http_method = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.name" = true
    "method.request.querystring.page" = true
    "method.request.querystring.size" = true
  }
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

# /v1/bookmark/{bookmarkFolderId}에 대한 통합 정의(GET)
resource "aws_api_gateway_integration" "bookmark_list_integration" {
  rest_api_id             = aws_api_gateway_rest_api.boda_api.id
  resource_id             = aws_api_gateway_resource.bookmark_list.id
  http_method             = aws_api_gateway_method.bookmark_list_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://backend.internal/api/v1/bookmark/{bookmarkFolderId}"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}


# /v1/bookmark/{bookmarkId}에 대한 통합 정의(DELETE)
resource "aws_api_gateway_integration" "bookmark_delete_integration" {
  rest_api_id             = aws_api_gateway_rest_api.boda_api.id
  resource_id             = aws_api_gateway_resource.bookmark_delete.id
  http_method             = aws_api_gateway_method.bookmark_delete_method.http_method
  integration_http_method = "DELETE"
  type                    = "HTTP"
  uri                     = "http://backend.internal/api/v1/bookmark/{bookmarkId}"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}

# /v1/bookmark/{bookmarkFolderId}/{spotId} 통합 정의(GET)
resource "aws_api_gateway_integration" "bookmark_create_integration" {
  rest_api_id             = aws_api_gateway_rest_api.boda_api.id
  resource_id             = aws_api_gateway_resource.bookmark_create.id
  http_method             = aws_api_gateway_method.bookmark_create_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://backend.internal/api/v1/bookmark/{bookmarkFolderId}/{spotId}"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}




###############################################

# /v1/spot/{spotId} 경로에 대한 통합 정의
resource "aws_api_gateway_integration" "spot_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.boda_api.id
  resource_id             = aws_api_gateway_resource.spot_get.id  # 각 메서드가 연결된 리소스 ID
  http_method             = aws_api_gateway_method.spot_get_methods.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://backend.internal/api/v1/spot/{spotId}"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}


# /v1/spot/쿼리 파라미터 메서드를 위한 통합 정의
resource "aws_api_gateway_integration" "spot_search_integration" {
  rest_api_id             = aws_api_gateway_rest_api.boda_api.id
  resource_id             = aws_api_gateway_resource.spot.id  # 쿼리 파라미터 메서드가 있는 리소스 ID
  http_method             = aws_api_gateway_method.spot_search_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://backend.internal/api/v1/spot" # 이 URI는 쿼리 파라미터가 없는 기본 엔드포인트
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
  
  request_parameters = {
    "integration.request.querystring.name" = "method.request.querystring.name"
    "integration.request.querystring.page" = "method.request.querystring.page"
    "integration.request.querystring.size" = "method.request.querystring.size"
  }
}


# API Gateway 배포 리소스
resource "aws_api_gateway_deployment" "boda_deployment" {
  depends_on  = [aws_api_gateway_method.api_methods]
  rest_api_id = aws_api_gateway_rest_api.boda_api.id
  stage_name  = var.stage_name
}

