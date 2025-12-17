terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Security Group
resource "aws_security_group" "flask_sg" {
  name        = "launch-wizard-1"
  description = "Security group for flask server"
  vpc_id      = "vpc-09caafeb48b0faa55" # Updated VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-flask-server-sg"
  }
}

# EC2 Instance
resource "aws_instance" "flask_server" {
  ami           = "ami-0c398cb65a93047f2" # Updated Ubuntu 22.04 AMI
  instance_type = "t3.micro"
  key_name      = "flask-server-key"      # Updated Key Pair
  subnet_id     = "subnet-0a9e032d96894c14d" # Updated Subnet ID

  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  tags = {
    Name = "my-flask-server"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = false
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Matches IMDSv2 Required
    http_put_response_hop_limit = 2
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

output "website_url" {
  value = "http://54.167.77.81" # Updated Public IP
}