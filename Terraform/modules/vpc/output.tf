
output "project_name" {
  value = var.project_name
}

output "region" {
  value = var.region
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}


output "pub_sub_1a_id" {
  value = aws_subnet.pub_sub_1a.id
}

output "pub_sub_2b_id" {
  value = aws_subnet.pub_sub_2b.id
}

output "priv_sub_3a_id" {
  value = aws_subnet.priv_sub_3a.id
}

output "priv_sub_4b_id" {
  value = aws_subnet.priv_sub_4b.id
}

output "igw_id" {
    value = aws_internet_gateway.igw
}