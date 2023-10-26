# Application loadbalancer security group
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "allow http access on port 80 inbound and outbound"
  vpc_id      = var.vpc_id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}

# webServer security group
resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "allow http access on port 80 from alb_sg-(inbound), allow all traffic-(outbound)"
  vpc_id      = var.vpc_id

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver_sg"
  }
}

# database security group
resource "aws_security_group" "mydb_sg" {
  name        = "mydb_sg"
  description = "allow webserver access to mysql database on port 3306-(inbound); allow all traffic-(outbound)"
  vpc_id      = var.vpc_id

  ingress {
    description     = "mysql access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mydb_sg"
  }
}

