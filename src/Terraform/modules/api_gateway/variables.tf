variable "rest_api_name" {
    description    = "Name of the API Gateway"
    type           = string
}

variable "stage_name" {
    description    = "API Gateway Stage"
    type           = string
}

variable "vpc_link_id" {
    description    = "VPC Link ID to connect to the private subnet"
    type           = string
}



# path = parent_id + path_part
variable "api_paths" {
    description  = "List of API paths and their descriptions"
    type         = map(object({
        path = string
        description = string
    }))
    default = {
        "auth/login"      = { path = "login", description = "로그인" },
        "auth/register"   = { path = "register", description = "회원가입 - 추가정보 입력" },
        "auth/logout"     = { path = "logout", description = "로그아웃" },
        "spot/get"        = { path = "spot", description = "여행지 조회" },
        "spot/search"     = { path = "spot", description = "여행지 검색" },
        "recommend/get"   = { path = "recommend", description = "AI 여행지 추천" },
        "bookmark/get"    = { path = "bookmark", description = "북마크 조회" },
        "bookmark/create" = { path = "bookmark", description = "북마크 생성" },
        "bookmark/delete" = { path = "bookmark", description = "북마크 삭제" },
    }
}

variable "api_methods" {
    description  = "List of API Methods and their description"
    type         = map(object({
        method = string
        uri    = string
    }))
    default = {
        "auth/login"      = { method = "GET", uri = "http://backend.internal/api/v1/login" },
        "auth/register"   = { method = "POST", uri = "http://backend.internal/api/v1/register" },
        "auth/logout"     = { method = "GET", uri = "http://backend.internal/api/v1/logout" },
        "spot/get"        = { method = "GET", uri = "http://backend.internal/api/v1/spot/{spotId}" },
        "spot/search"     = { method = "GET", uri = "http://backend.internal/api/v1/spot" },
        "recommend/get"   = { method = "POST", uri = "http://backend.internal/api/v1/recommend" },
        "bookmark/get"    = { method = "GET", uri = "http://backend.internal/api/v1/bookmark/{bookmarkId}" },
        "bookmark/create" = { method = "POST", uri = "http://backend.internal/api/v1/bookmark/folder" },
        "bookmark/delete" = { method = "DELETE", uri = "http://backend.internal/api/v1/bookmark/{bookmarkId}" },
    }
}

# user 관련 메서드 설정 (별도로 관리)
variable "user_paths" {
    description = "List of user-related API paths and their descriptions"
    type        = map(object({
        path        = string
        description = string
    }))
    default = {
        "user/get"    = { path = "get", description = "사용자 정보 조회" },
        "user/update" = { path = "update", description = "사용자 정보 수정" },
        "user/delete" = { path = "delete", description = "사용자 계정 삭제" },
    }
}

variable "user_methods" {
    description = "List of user-related API methods and their URIs"
    type        = map(object({
        method = string
        uri    = string
    }))
    default = {
        "user/get"    = { method = "GET", uri = "https://backend.example.com/user" },
        "user/update" = { method = "PATCH", uri = "https://backend.example.com/user" },
        "user/delete" = { method = "DELETE", uri = "https://backend.example.com/user" },
    }
}