include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../applications/RDS"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = ["plan","init"]
  mock_outputs = {
    vpc_id = "fake-vpc-id"
  }
}

dependency "subnet" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = ["plan","init"]
  mock_outputs = {
    database_subnets = "fake-database-subnets"
  }
}

inputs = {
  aws_region                          = "us-west-2"
  availability_zone                   = "us-west-2c"
  allocated_storage                   = 50
  backup_retention_period             = 7
  backup_window                       = "11:26-11:56"
  engine                              = "my-sql"
  engine_version                      = "8.0.28"
  family                              = "mysql8.0"
  identifier                          = "staging-db-server"
  instance_class                      = "db.t2.micro"
  maintenance_window                  = "mon:08:00-mon:08:30"
  major_engine_version                = "8.0"
  db_name                             = "staging-db-server"
  secret_name                         = "liverez-rds-CREDS"
  port                                = 3306
  master_parameter_group_name         = "learn-rds-0607"
  master_parameter_group_description  = "Adjust parameter"
  vpc_id                              = dependency.vpc.outputs.vpc_id
  cidr_blocks                         = "10.68.0.0/16"
  subnet_ids                          = dependency.subnet.outputs.database_subnets[*]
  cost_center  = "US"
  owner        = "Liverez"
  application  = "core-infrastructure"
  map-migrated = "false"
  environment  = "staging"
  
}
