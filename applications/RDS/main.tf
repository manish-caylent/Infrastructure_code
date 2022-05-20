locals {
  create_db_subnet_group    = var.create_db_subnet_group 
  create_db_parameter_group = var.create_db_parameter_group 
  create_db_instance        = var.create_db_instance 
  db_subnet_group_name    = var.create_db_subnet_group ? module.db_subnet_group.db_subnet_group_id : var.db_subnet_group_name
  parameter_group_name_id = var.create_db_parameter_group ? module.db_parameter_group.db_parameter_group_id : var.parameter_group_name
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


module "db_subnet_group" {
  source = "./modules/db_subnet_group"

  create = local.create_db_subnet_group

  name            = coalesce(var.db_subnet_group_name, var.identifier)
  use_name_prefix = var.db_subnet_group_use_name_prefix
  description     = var.db_subnet_group_description
  subnet_ids      = var.subnet_ids

  tags = local.tags
}

module "db_parameter_group" {
  source = "./modules/db_parameter_group"

  create = local.create_db_parameter_group

  name            = coalesce(var.parameter_group_name, var.identifier)
  use_name_prefix = var.parameter_group_use_name_prefix
  description     = var.parameter_group_description
  family          = var.family

  parameters = var.parameters

  tags = local.tags
}

module "sg" {
  source  = "./modules/db_security_group"
  name        = var.db_name
  description = "Complete MySQL example security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress = [
    {
      description = "Allow HTTPS connections from the internet"
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = [var.cidr_blocks]
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
  tags = local.tags
}
module "db_instance" {
  source = "./modules/db_instance"

  create     = local.create_db_instance
  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id
  license_model     = var.license_model
  secret_name                         = var.secret_name 
  db_name                             = var.db_name
  port                                = var.port
  domain                              = var.domain
  domain_iam_role_name                = var.domain_iam_role_name
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  vpc_security_group_ids = [module.sg.security_group_id]
  db_subnet_group_name   = local.db_subnet_group_name
  parameter_group_name   = local.parameter_group_name_id
  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  iops                = var.iops
  publicly_accessible = var.publicly_accessible
  ca_cert_identifier  = var.ca_cert_identifier

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  snapshot_identifier              = var.snapshot_identifier
  copy_tags_to_snapshot            = var.copy_tags_to_snapshot
  skip_final_snapshot              = var.skip_final_snapshot
  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null

  replicate_source_db         = var.replicate_source_db
  replica_mode                = var.replica_mode
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  max_allocated_storage       = var.max_allocated_storage
  monitoring_interval         = var.monitoring_interval
  monitoring_role_arn         = var.monitoring_role_arn
  monitoring_role_name        = var.monitoring_role_name
  monitoring_role_description = var.monitoring_role_description
  
  character_set_name = var.character_set_name
  timezone           = var.timezone

  enabled_cloudwatch_logs_exports        = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id        = var.cloudwatch_log_group_kms_key_id

  timeouts = var.timeouts

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups

  restore_to_point_in_time = var.restore_to_point_in_time
  s3_import                = var.s3_import

  tags = local.tags
}