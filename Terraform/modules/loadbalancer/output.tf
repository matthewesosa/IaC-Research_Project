output "alb_dns_name" {
  value = aws_lb.webserver_alb.dns_name
}

output "targetgroup_arn" {
  value = aws_lb_target_group.webserver_alb_target_group.arn
}