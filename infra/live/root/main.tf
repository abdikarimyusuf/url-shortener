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
  source = "../../modules/vpc"

  cidr               = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  db_subnets         = var.db_subnets
  availability_zones = var.availability_zones
  enable_nat_gateway = var.enable_nat_gateway

  name_prefix = local.name_prefix
  tags        = local.tags
}

# Security Groups 
module "alb_sg" {
  source = "../modules/security"

  name   = "${local.name_prefix}-alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { protocol = "tcp", from_port = 80, to_port = 80, cidr_blocks = ["0.0.0.0/0"] },
    { protocol = "tcp", from_port = 443, to_port = 443, cidr_blocks = ["0.0.0.0/0"] }
  ]

  # tags = local.tags
}

module "ecs_sg" {
  source = "../../modules/security"

  name   = "${local.name_prefix}-ecs-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { protocol = "tcp", from_port = var.frontend_port, to_port = var.frontend_port, security_groups = [module.alb_sg.sg_id] }
  ]

  #tags = local.tags
}

module "rds_sg" {
  source = "../../modules/security"

  name   = "${local.name_prefix}-rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { protocol = "tcp", from_port = 5432, to_port = 5432, security_groups = [module.ecs_sg.sg_id] }
  ]

  #tags = local.tags
}

#  Logging 
module "aws_cloudwatch_log_group" {
  source = "../../modules/logs"
  name   = "${local.name_prefix}-logs"
  #tags   = local.tags
}

# ECR
module "ecr" {
  source = "../../modules/ecr"

  repository_name = "${local.name_prefix}-app"
  #tags            = local.tags
}

#  ACM(TLS cert)
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

module "acm" {
  source = "../../modules/acm"

  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.main.zone_id

  tags = local.tags
}

# 
module "alb" {
  source = "../../modules/alb"

  name            = "${local.name_prefix}-alb"
  subnets         = module.vpc.public_subnet_ids
  security_groups = [module.alb_sg.sg_id]
  vpc_id          = module.vpc.vpc_id
  target_port     = var.frontend_port


  certificate_arn = module.acm.certificate_arn

  tags = local.tags
}

module "database" {
  source      = "../../modules/rds"
  name_prefix = "${local.name_prefix}-db"

  env = var.env

  engine         = "postgres"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  db_name        = var.db_name
  db_username    = var.db_username

  subnet_ids         = module.vpc.db_subnet_ids
  security_group_ids = [module.rds_sg.sg_id]

  multi_az         = var.db_multi_az
  backup_retention = var.db_backup_retention

  secret_name = "${local.name_prefix}-db-credential"

  #tags = local.tags
}

module "iam" {
  source = "../../modules/iam"

  cluster_name  = local.name_prefix
  db_secret_arn = module.database.secret_arn
  #tags          = local.tags
}

module "ecs_cluster" {
  source = "../../modules/ecs"

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

  frontend_image = var.frontend_image
  backend_image  = var.backend_image
  frontend_port  = var.frontend_port
  backend_port   = var.backend_port

  database_secret_arn = module.database.secret_arn

  subnets          = module.vpc.private_subnet_ids
  security_group   = [module.ecs_sg.sg_id]
  target_group_arn = module.alb.target_group_arn

  frontend_log_group = module.aws_cloudwatch_log_group.log_group_name
  backend_log_group  = module.aws_cloudwatch_log_group.log_group_name

  #tags = local.tags
}

module "r53" {
  source = "../../modules/route53"

  domain_name = trimsuffix(data.aws_route53_zone.main.name, ".")
  zone_id     = data.aws_route53_zone.main.zone_id
  alb_dns     = module.alb.alb_dns
  alb_zone_id = module.alb.alb_zone_id

  # You'll likely want this module to create a record for local.fqdn (see notes below)
  #record_name = local.fqdn

  # tags = local.tags
}
