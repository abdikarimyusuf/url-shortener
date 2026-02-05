locals {
  table_name = "${var.name}-${var.environment}-url-mappings"
}

resource "aws_dynamodb_table" "ddb" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = var.hash_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery
  }

  # TTL optional
  dynamic "ttl" {
    for_each = var.ttl_attribute == null ? [] : [1]
    content {
      attribute_name = var.ttl_attribute
      enabled        = true
    }
  }

  #tags = merge(var.tags, {
   # Name = local.table_name
  #})
}
