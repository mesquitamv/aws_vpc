output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_spec" {
  value = aws_subnet.private_subnet
}

output "public_subnet_spec" {
  value = aws_subnet.public_subnet
}
