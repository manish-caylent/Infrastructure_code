resource "aws_security_group" "sg" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  dynamic "ingress" {
    for_each = length(var.ingress) == 0 ? [] : var.ingress
    iterator = i
    content {
      from_port        = lookup(i.value, "from_port")
      to_port          = lookup(i.value, "to_port")
      protocol         = lookup(i.value, "protocol")
      description      = lookup(i.value, "description", null)
      cidr_blocks      = lookup(i.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(i.value, "ipv6_cidr_blocks", null)
      security_groups  = lookup(i.value, "security_groups", null)
      prefix_list_ids  = lookup(i.value, "prefix_list_ids", null)
      self             = lookup(i.value, "self", null)
    }

  }

  dynamic "egress" {
    for_each = length(var.egress) == 0 ? [] : var.egress
    iterator = e

    content {
      from_port        = lookup(e.value, "from_port")
      to_port          = lookup(e.value, "to_port")
      protocol         = lookup(e.value, "protocol")
      description      = lookup(e.value, "description", null)
      cidr_blocks      = lookup(e.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(e.value, "ipv6_cidr_blocks", null)
      security_groups  = lookup(e.value, "security_groups", null)
      prefix_list_ids  = lookup(e.value, "prefix_list_ids", null)
      self             = lookup(e.value, "self", null)
    }

  }

  tags = merge(var.tags, { "Name" : var.name })

}
