terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# AWS EC2 instance for deployment
resource "aws_instance" "devops_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
  instance_type = "t2.micro"
  
  tags = {
    Name = "devops-assistant-server"
  }
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker git
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  EOF
}

# Docker container locally
resource "docker_image" "app_image" {
  name = "devops-assistant:latest"
  build {
    context = "../"
  }
}

resource "docker_container" "app_container" {
  name  = "devops-app"
  image = docker_image.app_image.name
  ports {
    internal = 5000
    external = 5000
  }
}

output "instance_ip" {
  value = aws_instance.devops_server.public_ip
}