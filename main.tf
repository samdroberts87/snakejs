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
  ami             = "ami-08f7912c15ca96832"
  instance_type   = "t2.micro"
  key_name        = "Pipeline"  # Ensure this matches the case of the actual key pair name in AWS
  vpc_security_groups_ids = ["sg-02dd272262f14a262"]

  tags = {
    Name = "snake_game_server"
  }
}

output "Name" {
  value = aws_instance.app_server.tags.Name
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}

resource "null_resource" "save_output_to_file" {
  provisioner "local-exec" {
    command = "echo \"server_name=${aws_instance.app_server.tags.Name} server_IP=${aws_instance.app_server.public_ip} ssh_private_key_file=Pipeline.pem\" > inventory.ini"
  }
}
