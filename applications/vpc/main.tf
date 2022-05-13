locals {
  tags = {
    Environment  = var.environment
    Terraform    = "true"
    CostCenter   = var.cost_center
    OwnedBy      = var.owner
    Application  = var.application
    DeploymentID = random_id.deploymentID.id
  }
}

resource "random_id" "deploymentID" {
  byte_length = 8
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr
  azs              = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false

  manage_default_network_acl = true
  public_dedicated_network_acl = true
  private_dedicated_network_acl = true
  database_dedicated_network_acl = true 

  tags = local.tags
}

module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"

  name        = var.tgw_name
  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc = {
      vpc_id       = module.vpc.vpc_id
      subnet_ids   = module.vpc.private_subnets
      dns_support  = true
      ipv6_support = true
      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        }
      ]
    }
  }
  tags = local.tags
}