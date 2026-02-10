locals {
  name_prefix = lower("${var.project}-${var.environment}")

  tags = merge(
    {
      Project     = var.project
      Environment = var.environment
    },
    var.extra_tags
  )


  fqdn = "${var.environment}.${var.sub_domain_name}.${var.domain_name}"
}

# Networkk
module "vpc" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/vpc?ref=main"

  cidr               = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnet
  availability_zones = var.availability_zones
  enable_nat_gateway = var.enable_nat_gateway

  name_prefix = local.name_prefix
  tags        = local.tags
}

# Security Groups 
module "alb_sg" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/security?ref=main"

  name   = "${local.name_prefix}-alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { protocol = "tcp", from_port = 80, to_port = 80, cidr_blocks = ["0.0.0.0/0"] },
    { protocol = "tcp", from_port = 443, to_port = 443, cidr_blocks = ["0.0.0.0/0"] }
  ]

  # tags = local.tags
}

module "ecs_sg" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/security?ref=main"

  name   = "${local.name_prefix}-ecs-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { protocol = "tcp", from_port = var.ecs_port, to_port = var.ecs_port, security_groups = [module.alb_sg.sg_id] }
  ]

  #tags = local.tags
}


module "endpoints_sg" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/security?ref=main"

  name   = "${local.name_prefix}-endpoints-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { protocol = "tcp", from_port = 443, to_port = 443, cidr_blocks = [var.vpc_cidr] }
  ]

  #tags = local.tags
}

#  Logging 
module "aws_cloudwatch_log_group" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/logs?ref=main"
  name   = "${local.name_prefix}-logs"
  #tags   = local.tags
}

# ECR
module "ecr" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/ecr?ref=main"

  repository_name = "${local.name_prefix}-app"
  #tags            = local.tags
}

#  ACM(TLS cert)
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

module "acm" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/acm?ref=main"

  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.main.zone_id

  tags = local.tags
}

# 
module "alb" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/alb?ref=main"

  name            = "${local.name_prefix}-alb"
  subnets         = module.vpc.public_subnet_ids
  security_groups = [module.alb_sg.sg_id]
  vpc_id          = module.vpc.vpc_id
  target_port     = var.ecs_port


  certificate_arn = module.acm.certificate_arn

  tags = local.tags
}
module "waf" {
  source      = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/waf?ref=main"
  name_prefix = "${local.name_prefix}-waf"
  alb_arn     = module.alb.alb_arn
  rate_limit  = 100 # per ip

}

module "iam" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/iam?ref=main"

  cluster_name       = local.name_prefix
  dynamodb_table_arn = module.dynamodb.table_arn
  #tags          = local.tags
}

module "ecs_cluster" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/ecs?ref=main"

  cluster_name = "${local.name_prefix}-cluster"
  service_name = "${local.name_prefix}-service"
  family       = "${local.name_prefix}-task"

  vpc_id        = module.vpc.vpc_id
  cpu           = var.ecs_cpu
  memory        = var.ecs_memory
  desired_count = var.ecs_desired_count

  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  region             = var.region

  image          = var.image
  container_port = var.container_port

  TABLE_NAME = module.dynamodb.table_name



  subnets          = module.vpc.private_subnet_ids
  security_group   = [module.ecs_sg.sg_id]
  target_group_arn = module.alb.target_group_arn

  container_log_group = module.aws_cloudwatch_log_group.log_group_name

  #tags = local.tags
}

module "r53" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/route53?ref=main"

  domain_name = trimsuffix(data.aws_route53_zone.main.name, ".")
  zone_id     = data.aws_route53_zone.main.zone_id
  alb_dns     = module.alb.alb_dns
  alb_zone_id = module.alb.alb_zone_id

  # You'll likely want this module to create a record for local.fqdn (see notes below)
  #record_name = local.fqdn

  # tags = local.tags
}

module "endpoints" {
  source                  = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/endpoints?ref=main"
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  private_route_table_ids = module.vpc.private_route_table_ids
  endpoints_sg_id         = module.endpoints_sg.sg_id

}

module "dynamodb" {
  source = "git::https://github.com/abdikarimyusuf/url-shortener.git//infra/modules/dynamodb?ref=main"

  name        = "${local.name_prefix}-ddb"
  environment = var.environment

  # Optional: enable TTL if you want
  # ttl_attribute = "expires_at"

  #tags = local.tags
}


