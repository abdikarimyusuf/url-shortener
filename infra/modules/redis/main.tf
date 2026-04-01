resource "aws_elasticache_subnet_group" "redis" {
  name       = var.name
  subnet_ids = var.subnet_ids
}


resource "aws_elasticache_cluster" "cluster" {
  cluster_id      = var.name
  engine          = "redis"
  node_type       = var.node_type
  num_cache_nodes = 1

  subnet_group_name  = aws_elasticache_subnet_group.redis.name
  security_group_ids = var.security_group_ids

  port = 6379

  
}