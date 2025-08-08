terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.54"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source          = "../../modules/network"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  aws_region      = var.aws_region
}

module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
}

module "observability" {
  source       = "../../modules/observability"
  project_name = var.project_name
}

module "alb" {
  source            = "../../modules/alb"
  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  container_port    = var.container_port
  health_check_path = "/health"
}

module "ecs" {
  source              = "../../modules/ecs_service"
  project_name        = var.project_name
  aws_region          = var.aws_region
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
  container_port      = var.container_port
  cpu                 = var.cpu
  memory              = var.memory
  repository_url      = module.ecr.repository_url
  image_tag           = "latest"
  log_group_name      = module.observability.log_group_name
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
}

module "iam_github_oidc" {
  source        = "../../modules/iam_github_oidc"
  project_name  = var.project_name
  github_repo   = var.github_repo
  oidc_sub      = var.oidc_sub
  passrole_arns = [
    module.ecs.task_execution_role_arn,
    module.ecs.task_role_arn
  ]
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
output "ecr_repository_url" {
  value = module.ecr.repository_url
}
output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}
output "ecs_service_name" {
  value = module.ecs.service_name
}
output "github_oidc_role_arn" {
  value = module.iam_github_oidc.github_actions_role_arn
}
