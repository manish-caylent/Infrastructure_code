variable "name" {
  description = "The name of the security group."
  type        = string
}

variable "description" {
  description = "The security group description. Defaults to \"Managed by Terraform\"."
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created."
  type        = string
}

variable "ingress" {
  description = "List of maps containing ingress rules that will be configured for in the security group."
  type        = any
}

variable "egress" {
  description = "List of maps containing egress rules that will be configured for in the security group."
  type        = any
}


variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself."
  type        = bool
  default     = false
}

variable "tags" {

  description = "A map of tags to assign to the resource."
  type        = map(any)
  validation {
    condition = (
      try(length(lookup(var.tags, "CostCenter")) > 0, false) &&
      try(length(lookup(var.tags, "OwnedBy")) > 0, false) &&
      try(length(lookup(var.tags, "Terraform")) > 0, false) &&
      try(length(lookup(var.tags, "Application")) > 0, false) &&
      try(length(lookup(var.tags, "DeploymentID")) > 0, false) &&
      try(length(lookup(var.tags, "map-migrated")) > 0, false) &&
      try(length(lookup(var.tags, "Environment")) > 0, false)
    )

    error_message = "Not all obrigatory tags (CostCenter, OwnedBy, Terraform, Application, DeploymentID, Environment, map-migrated) are present, please review."
  }
}
