locals {
  anywhere = "0.0.0.0/0"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = {
    Name = "BODA VPC"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.selected.names[0]
  
  tags = {
    Name = count.index == 0 ? "Frontend BODA subnet" : "NAT BODA subnet"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs) - 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index + 1]
  availability_zone = data.aws_availability_zones.selected.names[0]
  
  tags = {
    Name = "${var.instance_names[count.index + 1]} BODA subnet"
  }
}

resource "aws_subnet" "db" {
  count             = length(var.db_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.selected.names[count.index]
  
  tags = {
    Name = "${data.aws_availability_zones.selected.names[count.index]} DB BODA subnet"
  }
}

resource "aws_db_subnet_group" "db" {
    subnet_ids = aws_subnet.db[*].id

    tags = {
        Name = "BODA MySQL RDS subnet group"
    }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "BODA internet gateway"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = data.aws_eip.nat.id
  subnet_id = aws_subnet.public[1].id

  tags = {
    Name = "BODA nat gateway"
  }

  depends_on = [ aws_internet_gateway.main ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = local.anywhere
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "BODA public route table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = local.anywhere
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "BODA private route table"
  }
}

resource "aws_route_table_association" "public" {
  count = 2
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs) - 1
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [local.anywhere]
  }

  ingress {
    description = "react app localhost"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = [local.anywhere]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [local.anywhere]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [local.anywhere]
  }

  tags = {
    Name = "BODA public security group"
  }
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [local.anywhere]
  }

  ingress {
    description = "MySQL RDS"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [local.anywhere]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [local.anywhere]
  }

  tags = {
    Name = "BODA private security group"
  }
}