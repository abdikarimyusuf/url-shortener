output "redis_endpoint" {
  value = aws_elasticache_cluster.cluster.cache_nodes[0].address
}

output "port" {
  value = aws_elasticache_cluster.cluster.port
}