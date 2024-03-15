terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-08f7912c15ca96832"
  instance_type = "t2.micro"
  key_name      = "pipeline" // Ensure this matches your existing key pair name

  tags = {
    Name = "snake_game_server"
  }
}

resource "null_resource" "save_output_to_file" {
  provisioner "local-exec" {
    command = <<EOT
echo "server_name=snake_game_server server_IP=${aws_instance.app_server.public_ip} ssh_private_key_file=pipeline.pem" > inventory.ini
aws ec2 get-key-pair --key-name pipeline --query 'KeyPairs[0].KeyMaterial' --output text > pipeline.pem
EOT
  }
}
