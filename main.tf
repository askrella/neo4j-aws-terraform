terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }
}

provider "aws" {
    region = "eu-central-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "primary" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_key_pair" "steve" {
  key_name  = "Steve"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+72v5e+zKLZA2uFzDtojz0V8QvTXZu7l5SQwaqifn3 stve.hb@gmail.com"
}

module "cluster" {
  source = "./cluster"
  environment = "test"
  project = "test"
  key_name = aws_key_pair.steve.key_name
  volume_size = "10"
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.primary.id]

  providers = {
    aws: aws
  }
}
