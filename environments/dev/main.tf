module "vpc" {
  source       = "../../modules/vpc"
  project_name = var.project_name
}

module "security" {
  source       = "../../modules/security"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "autoscaling" {
  source       = "../../modules/autoscaling"
  project_name = var.project_name
  subnets      = module.vpc.app_subnets
  app_sg       = module.security.app_sg
}

module "alb" {
  source         = "../../modules/alb"
  project_name   = var.project_name
  public_subnets = module.vpc.public_subnets
  vpc_id         = module.vpc.vpc_id
  alb_sg         = module.security.alb_sg
  asg_name       = module.autoscaling.asg_name
}

module "rds" {
  source       = "../../modules/rds"
  project_name = var.project_name
  db_sg        = module.security.db_sg
  db_subnets   = module.vpc.private_db_subnets
}
