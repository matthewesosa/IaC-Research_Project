resource "aws_db_subnet_group" "mydb-subnet" {
  name       = var.mydb_sub_name
  subnet_ids = [var.priv_sub_3a_id, var.priv_sub_4b_id] # Replace with your private subnet IDs
}

resource "aws_db_instance" "mydb" {
  identifier              = "testdb-instance"
  engine                  = "mysql"
  instance_class          = "db.t2.small"
  allocated_storage       = 20
  username                = var.mydb_username
  password                = var.mydb_password
  multi_az                = true
  publicly_accessible     = false
  skip_final_snapshot     = true

  vpc_security_group_ids = [var.mydb_sg_id] # Replace with your desired security group ID

  db_subnet_group_name = aws_db_subnet_group.mydb-subnet.name

  tags = {
    Name = "mydb-test"
  }
}