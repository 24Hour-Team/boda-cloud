provider "aws" {
    # provider는 terraform이 사용할 클라우드 서비스를 명시
    region = "ap-northeast-2"
}

terraform {
    # terraform 버전을 명시해준다.
    required_version = "1.10.0"


    # 필수로 사용할 provider를 정해준다
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.64.0"
            
        }
    }
}
