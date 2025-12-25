# ----------------- VPC -----------------
resource "aws_vpc" "tmdb_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tmdb-vpc"
  }
}

# ----------------- Public Subnet -----------------
resource "aws_subnet" "tmdb_subnet" {
  vpc_id                  = aws_vpc.tmdb_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "tmdb-public-subnet"
  }
}

# ----------------- Internet Gateway -----------------
resource "aws_internet_gateway" "tmdb_igw" {
  vpc_id = aws_vpc.tmdb_vpc.id

  tags = {
    Name = "tmdb-igw"
  }
}

# ----------------- Route Table -----------------
resource "aws_route_table" "tmdb_rt" {
  vpc_id = aws_vpc.tmdb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tmdb_igw.id
  }

  tags = {
    Name = "tmdb-rt"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "tmdb_rta" {
  subnet_id      = aws_subnet.tmdb_subnet.id
  route_table_id = aws_route_table.tmdb_rt.id
}

# ----------------- Security Group -----------------
resource "aws_security_group" "tmdb_sg" {
  name        = var.sg_name
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = aws_vpc.tmdb_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tmdb-sg"
  }
}

# ----------------- Key Pair -----------------
resource "aws_key_pair" "tmdb_key" {
  key_name   = "tmdb-key"
  public_key = file(var.key_pair_path)
}

# ----------------- Fetch Latest Amazon Linux 2 AMI -----------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ----------------- EC2 Instance -----------------
resource "aws_instance" "tmdb_ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.tmdb_subnet.id
  key_name                    = aws_key_pair.tmdb_key.key_name
  vpc_security_group_ids      = [aws_security_group.tmdb_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.ec2_name
  }
}

# ----------------- Elastic IP -----------------
resource "aws_eip" "tmdb_eip" {
  instance = aws_instance.tmdb_ec2.id
}
