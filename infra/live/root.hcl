locals {
  project = "url-shortener"
  region  = "eu-west-2"

  common_tags = {
    project = local.project
    ManagedBy = "terragrunt"
  }
  }

  remote_state {
    backend = "s3"
    config = {
        bucket       = "notepad-tfstate2"
key          = "${path_relative_to_include()}/terraform.tfstate"
region       = "eu-west-2"
encrypt      = true

    }


  }

  terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-lock-timeout=5m"
    ]
  }
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"

  default_tags {
    tags = ${jsonencode(local.common_tags)}
  }
}
EOF
}

  inputs= { 
    project = local.project
     region  = local.region
  tags    = local.common_tags
    }

