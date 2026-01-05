variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Public subnet CIDR block"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID"
  default     = "" # will fetch latest in main.tf
}

variable "key_pair_path" {
  description = "Path to your SSH public key file to import into EC2"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "CIDR block allowed to SSH (use your public IP or 0.0.0.0/0 for all)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "sg_name" {
  description = "Security Group name"
  default     = "tmdb-sg"
}

variable "ec2_name" {
  description = "Name tag for EC2 instance"
  default     = "tmdb-ec2"
}
