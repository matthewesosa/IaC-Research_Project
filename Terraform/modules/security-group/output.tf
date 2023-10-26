
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "webserver_sg_id" {
  value = aws_security_group.webserver_sg.id
}

output "mydb_sg_id" {
  value = aws_security_group.mydb_sg.id
}