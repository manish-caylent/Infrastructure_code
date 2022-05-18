include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../applications/vpc"
}

inputs = {
  vpc_name         = "prod-vpc"
  cidr             = "10.78.0.0/16"
  aws_region       = "us-west-2"
  private_subnets  = ["10.78.8.0/24", "10.78.9.0/24"]
  public_subnets   = ["10.78.0.0/24", "10.78.1.0/24"]
  database_subnets = ["10.78.16.0/24", "10.78.17.0/24"]
  tgw_name = "prod-tgw"
  #tags
  cost_center = "USA"
  owner       = "iiq"
  application = "vpc"
  environment = "prod"
}