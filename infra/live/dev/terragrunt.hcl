include"root" {
    path = find_in_parent_folders("root.hcl")

}

terraform {
    source = "../root"
}

inputs = {
  environment   = "dev"
  name_prefix   = "shorter-dev"

domain_name     = "abdikarim.co.uk"
sub_domain_name = "app"
env             = "dev"

vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
db_subnets         = ["10.0.5.0/24", "10.0.6.0/24"]
availability_zones = ["eu-west-2a", "eu-west-2b"]
enable_nat_gateway = true

  desired_count = 2
  ecs_cpu           = "512"
ecs_memory        = "1024"

  db_instance_class      = "db.t3.micro"
db_multi_az            = false
db_backup_retention    = 1
db_deletion_protection = false


}

