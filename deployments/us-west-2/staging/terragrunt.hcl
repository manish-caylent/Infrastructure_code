locals {
  aws_region = "us-west-2"
}

remote_state {
  backend = "s3"
  config = {
    bucket = "tfstate-${local.aws_region}"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
  }
  generate = {
    path      = "tf-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = "${local.aws_region}"
}
EOF
}
