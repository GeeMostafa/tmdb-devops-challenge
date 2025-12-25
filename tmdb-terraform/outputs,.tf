output "public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_eip.tmdb_eip.public_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.tmdb_vpc.id
}

output "subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.tmdb_subnet.id
}
