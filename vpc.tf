# Create new vpc
resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${local.name}-vpc-1"
  }
}

# Create new subnet
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.region_az

  tags = {
    Name = "${local.name}-subnet-1"
  }
}

# Create Internet Gateway for outbound traffic to Internet
resource "aws_internet_gateway" "gw_1" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = "${local.name}-internet-gw"
  }

}

# Required Route Table to forward traffic to the Internet Gateway for outbound connectivity
resource "aws_route_table" "rt_1" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_1.id
  }

  tags = {
    Name = "${local.name}-rt-gw-1"
  }
}

resource "aws_main_route_table_association" "main_rt" {
  vpc_id         = aws_vpc.vpc_1.id
  route_table_id = aws_route_table.rt_1.id
}