output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "app_subnets" {
  value = aws_subnet.private_app[*].id
}

output "db_subnets" {
  value = aws_subnet.private_db[*].id
}

output "private_db_subnets" {
  value = aws_subnet.private_db[*].id
}
