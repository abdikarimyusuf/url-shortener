data "aws_region" "current" {}

locals {
  region = data.aws_region.current.name

  # Interface endpoints 
  interface_services_base = [
    "ecr.api",
    "ecr.dkr",
    "logs",
  ]



  interface_services_optional = var.enable_secretsmanager ? ["secretsmanager"] : []
  interface_services          = concat(local.interface_services_base, local.interface_services_optional)

  # Full service names like com.amazonaws.eu-west-2.ecr.api
  interface_service_names = [
    for s in local.interface_services : "com.amazonaws.${local.region}.${s}"
  ]
}


# Gateway Endpoints


resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids

  tags = merge(var.tags, { Name = "vpce-dynamodb" })
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids

  tags = merge(var.tags, { Name = "vpce-s3" })
}


# Interface Endpoints (ENIs in subnets)

resource "aws_vpc_endpoint" "interface" {
  for_each = toset(local.interface_service_names)

  vpc_id             = var.vpc_id
  service_name       = each.value
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.private_subnet_ids
  security_group_ids = [var.endpoints_sg_id]

  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "vpce-${replace(each.value, "com.amazonaws.${local.region}.", "")}"
  })
}
