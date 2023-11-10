resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "jhc-vpc-${local.ws}"
  }
}

resource "aws_subnet" "main" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidrs[count.index]
  availability_zone = local.azs_names[0]

  tags = {
    Name = "jhc-subnet-${local.ws}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "rtb"
  }
}

resource "aws_route_table_association" "main" {
  count = 2
  subnet_id = aws_subnet.main.*.id[count.index]
  route_table_id = aws_route_table.main.id
}