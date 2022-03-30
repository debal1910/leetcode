terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
  backend "s3" {
    bucket = "terraformdebal"
    key    = "state/terraform.state"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "project3"
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "sg_bastion_host" {
  name        = "sg bastion host"
  description = "bastion host security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_app_host" {
  name        = "sg app host"
  description = "application host security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "allow all for subnet"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_alb_host" {
  name        = "sg alb host"
  description = "application loadbalancer security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "allow all for port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_host" {

  ami                         = "ami-04505e74c0741db8d"
  instance_type               = "t2.micro"
  key_name                    = "terraform"
  vpc_security_group_ids      = [aws_security_group.sg_bastion_host.id]
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "jenkins_host" {

  ami                         = "ami-04505e74c0741db8d"
  instance_type               = "t2.micro"
  key_name                    = "terraform"
  vpc_security_group_ids      = [aws_security_group.sg_app_host.id]
  subnet_id                   = element(module.vpc.private_subnets, 0)
  associate_public_ip_address = true
  tags = {
    Name = "jenkins"
  }
}

output "bastionServer" {
  value = aws_instance.bastion_host.public_ip
}

output "jenkinsServer" {
  value = aws_instance.jenkins_host.private_ip
}


resource "aws_instance" "app_host" {

  ami                         = "ami-04505e74c0741db8d"
  instance_type               = "t2.micro"
  key_name                    = "terraform"
  vpc_security_group_ids      = [aws_security_group.sg_app_host.id]
  subnet_id                   = element(module.vpc.private_subnets, 1)
  associate_public_ip_address = true
  tags = {
    Name = "app"
  }
}

output "appServer" {
  value = aws_instance.app_host.private_ip
}
