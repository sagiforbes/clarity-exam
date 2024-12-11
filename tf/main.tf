terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.10.2"
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "clarity-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "Name" = "clarity-public-subnet"
  }

  private_subnet_tags = {
    "Name" = "clarity-private-subnet"
  }

  tags = {
    "Environment" = "clarity"
  }
}

data "aws_route_table" "public_route_tables" {
  for_each = toset(module.vpc.public_subnets)
  subnet_id = each.value
}

locals {
  public_route_table_ids = [for rt in data.aws_route_table.public_route_tables : rt.id]
}


data "aws_route_table" "private_route_tables" {
  for_each = toset(module.vpc.private_subnets)
  subnet_id = each.value
}


resource "aws_security_group" "allow_http_https" {
  vpc_id = module.vpc.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS access"
  }

  tags = {
    Name        = "allow-http-https"
    Environment = "clarity"
  }
}


module "cloudfront" {
  source      = "./modules/cloudfront"
  bucket_name = "clarity.sagiforbes"
  tags = {
    Environment = "clarity"
  }
}

module "cognito" {
  source         = "./modules/cognito"
  user_pool_name = "clarity-user-pool"
  test_user_name = "test.clarity"
  tags = {
    Environment = "clarity"
  }
}

module "sqs" {
  source = "./modules/sqs"
  tags   = {
    Environment = "clarity"
  }
}

module "lambda" {
  source            = "./modules/lambda"
  docker_image_uri  = var.lambda_docker_image
  region = var.region
}
