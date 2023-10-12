# Defining vpc resource 'vpc'
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  enable_dns_support =  true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# Defining the internet gateway resource 'igw' and attaching it to 'vpc'
resource "aws_internet_gateway" "igw" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# using 'data source' to obtain a list of all avalablility zones in region
data "aws_availability_zones" "az-list" {}

# defining public_subnet pub_sub_1a in AZ-a
resource "aws_subnet" "pub_sub_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_1a_cidr
  availability_zone       = data.aws_availability_zones.az-list.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "pub_sub_1a"
  }
}

# defining public_subnet pub_sub_2b in AZ-b
resource "aws_subnet" "pub_sub_2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_2b_cidr
  availability_zone       = data.aws_availability_zones.az-list.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "pub_sub_2b"
  }
}


# define public route table and add public route
resource "aws_route_table" "pub_rt" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags       = {
    Name     = "pub_rt"
  }
}

# associating public subnet in AZ-a, pub_sub_1a with pub_rt
resource "aws_route_table_association" "pub_sub_1a-with-route_table_association" {
  subnet_id           = aws_subnet.pub_sub_1a.id
  route_table_id      = aws_route_table.pub_rt.id
}

# associate public subnet AZ-b, pub_sub_2b with pub_rt
resource "aws_route_table_association" "pub-sub-2-b_route_table_association" {
  subnet_id           = aws_subnet.pub_sub_2b.id
  route_table_id      = aws_route_table.pub_rt.id
}

# defining private subnet in AZ-a, priv-sub-3a
resource "aws_subnet" "pri_sub_3a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.priv_sub_3a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false  #this is a private subnet

  tags      = {
    Name    = "pri-sub-3a"
  }
}

# defining private subnet in AZ-b, priv_sub_4b
resource "aws_subnet" "priv_sub_4b" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.priv_sub_4b_cidr
  availability_zone        = data.aws_availability_zones.az-list.names[1]
  map_public_ip_on_launch  = false  #this is a private subnet

  tags      = {
    Name    = "priv_sub_4b"
  }
}
