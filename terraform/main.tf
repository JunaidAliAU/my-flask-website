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
resource "aws_security_group" "existing_sg" {
  name        = "launch-wizard-1"
  description = "launch-wizard-1 created 2025-12-07T16:11:14.164Z"
  vpc_id      = "vpc-005011d1b522ff251"

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

  tags = {}
}

# EC2 Instance
resource "aws_instance" "portfolio" {
  ami           = "ami-0fa3fe0fa7920f68e"
  instance_type = "t3.micro"
  key_name      = "gohardevops"
  subnet_id     = "subnet-0633cc42f49db6fad"

  vpc_security_group_ids = [aws_security_group.existing_sg.id]

  tags = {
    Name = "gohar-devops"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = false
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

output "website_url" {
  value = "http://3.85.222.141"
}