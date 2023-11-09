# elastic ip for the nat-gateway in pub_sub_1a (first public subnet - in availability zone a)
resource "aws_eip" "eip-nat-a" {
  domain    = "vpc"

  tags   = {
    Name = "eip-nat-a"
  }
}

# elastic ip for the nat-gateway in pub_sub_1a (second public subnet - in availability zone b)
resource "aws_eip" "eip-nat-b" {
  domain    = "vpc"

  tags   = {
    Name = "eip-nat-b"
  }
}

# nat in public subnet pub_sub_1a in AZ-a
resource "aws_nat_gateway" "nat-a" {
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id     = var.pub_sub_1a_id

  tags   = {
    Name = "nat-a"
  }

  # depends on: tells terraform that internet gateway igw should be created first (nat depends on igw)
  depends_on = [var.igw_id]
}

# nat in public subnet pub_sub_2b in AZ-b
resource "aws_nat_gateway" "nat-b" {
  allocation_id = aws_eip.eip-nat-b.id
  subnet_id     = var.pub_sub_2b_id

  tags   = {
    Name = "nat-b"
  }

# depends on: tells terraform that internet gateway igw should be created first (nat depends on igw)
  depends_on = [var.igw_id]
}

# private route table priv-rt-a and addition of route through nat-a
resource "aws_route_table" "priv-rt-a" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-a.id
  }

  tags   = {
    Name = "priv-rt-a"
  }
}

# associating private subnet priv_sub_3a with priv-rt-a
resource "aws_route_table_association" "priv_sub_3a-with-priv-rt-a" {
  subnet_id         = var.priv_sub_3a_id
  route_table_id    = aws_route_table.priv-rt-a.id
}

# private route table priv-rt-b and addition of route through nat-b
resource "aws_route_table" "priv-rt-b" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-b.id
  }

  tags   = {
    Name = "priv-rt-b"
  }
}

# associating private subnet priv_sub_4b with priv-rt-b
resource "aws_route_table_association" "priv_sub_4b-with-priv-rt-b" {
  subnet_id         = var.priv_sub_4b_id
  route_table_id    = aws_route_table.priv-rt-b.id
}