resource "aws_security_group" "sg" {
  name   = var.name
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
      protocol  = ingress.value.protocol
      # Use cidr_blocks if provided
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)

      # Allow traffic from another SG if provided
      security_groups = lookup(ingress.value, "security_groups", null)
    }
  }


  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = lookup(egress.value, "description", null)

      from_port = egress.value.from_port
      to_port   = egress.value.to_port
      protocol  = egress.value.protocol

      cidr_blocks     = lookup(egress.value, "cidr_blocks", [])
      security_groups = lookup(egress.value, "security_group_ids", [])

    }
  }

  tags = {
    Name = var.name
  }
}


