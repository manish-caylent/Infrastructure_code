include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../applications/vpc"
}

inputs = {
  vpc_name         = "staging-vpc"
  cidr             = "10.68.0.0/16"
  aws_region       = "us-west-2"
  private_subnets  = ["10.68.8.0/24", "10.68.9.0/24"]
  public_subnets   = ["10.68.0.0/24", "10.68.1.0/24"]
  database_subnets = ["10.68.16.0/24", "10.68.17.0/24"]
  tgw_name         = "staging-tgw"
  #tags
  cost_center = "usa"
  owner       = "manish"
  application = "vpc"
  environment = "staging"
}