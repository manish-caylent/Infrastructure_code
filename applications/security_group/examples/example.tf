terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74"
    }
  }
}

provider "aws" {
  region = "us-west-2"

  assume_role {
    role_arn = "arn:aws:iam::111111111111:role/Terraform"
  }

  default_tags {
    tags = {
      Terraform = true
    }
  }
}


module "security-group" {
  source = "../"
  name   = "iiq-test-sg"
  vpc_id = "vpc-11112222333344445"
  ingress = [
    {
      description = "Allow HTTPS connections from the internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTP connections from the internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress = [
    {
      description = "Default rule"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]


  tags = {
    Environment  = "Dev"
    Terraform    = true
    CostCenter   = 00000
    OwnedBy      = "iiq"
    Application  = "App"
    DeploymentID = "UniqId"
  }
}