
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "webServer_sg_id" {
  value = aws_security_group.webServer_sg.id
}

output "mydb_sg_id" {
  value = aws_security_group.mydb_sg.id
}