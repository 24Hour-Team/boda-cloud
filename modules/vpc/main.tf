##################
### VPC
##################
resource "aws_vpc" "main" {
  cidr_block              = "10.0.0.0/16"
  enable_dns_support      = true
  enable_dns_hostnames    = true
  tags = {
   Name                   = "main-vpc"
  }
}


##################
### Subnet
##################

locals {
  public_subnet_length     = length(var.public_subnets_cidr)
  private_subnet_length    = length(var.private_subnets_cidr)
  availability_zone_length = length(var.availability_zones)
}



# 퍼블릭 서브넷 생성(프론트엔드 서버용)
resource "aws_subnet" "public" {
  count = local.public_subnet_length

  vpc_id                   = aws_vpc.main.id
  cidr_block               = var.public_subnets_cidr[count.index]

  availability_zone        = var.availability_zones[count.index % local.availability_zone_length]
  map_public_ip_on_launch  = true                   # Public IP를 자동으로 할당

  tags = {
    Name                   = "public-subnet-${count.index + 1}"
    NetworkType            = "Public"
  }
}


# 프라이빗 서브넷 생성(백엔드, DB, AI 서버용)
resource "aws_subnet" "private" {
  count = local.private_subnet_length
  
  vpc_id                   = aws_vpc.main.id
  cidr_block               = var.private_subnets_cidr[count.index]

  availability_zone        = var.availability_zones[count.index % local.availability_zone_length]

  tags = {
    Name                   = "private-subnet-${count.index + 1}"
    NetworkType            = "Private"
  }
}



##################
### Route Table
##################

# 인터넷 게이트웨이 생성(퍼블릭 서브넷용)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name                   = "internet-gateway"
  }
}



# 퍼블릭 서브넷에 대한 라우트 테이블 설정
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block             = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.gw.id
  }
  tags = {
    Name                   = "public-route-table"
    NetworkType            = "Public"
  }
}

#라우트 테이블과 서브넷을 연결
resource "aws_route_table_association" "public_subnet" {
  count = local.public_subnet_length

  subnet_id                = aws_subnet.public[count.index].id
  route_table_id           = aws_route_table.public.id
}



# 프라이빗 서브넷에 대한 라우트 테이블 설정

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name                   = "private-route-table"
    NetworkType            = "Private"
  }
}

resource "aws_route_table_association" "private" {
  count = local.private_subnet_length

  subnet_id                = aws_subnet.private[count.index].id
  route_table_id           = aws_route_table.private.id
}