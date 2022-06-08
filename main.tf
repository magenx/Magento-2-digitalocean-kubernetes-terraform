


////////////////////////////////////////////////[ INFRASTRUCTURE DEPLOYMENT ]/////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create VPC and base networking layout
# # ---------------------------------------------------------------------------------------------------------------------#
module "network" {
  source       = "./modules/network"
  project      = local.project
  vpc_cidr     = var.vpc_cidr
  region       = var.region
}

# # ---------------------------------------------------------------------------------------------------------------------#
# Create load balancer with domain and dns settings + ssl letsencrypt
# # ---------------------------------------------------------------------------------------------------------------------#
module "loadbalancer" {
  source           = "./modules/loadbalancer"
  project          = local.project
  region           = var.region
  vpc_uuid         = module.network.vpc_uuid
  size             = var.loadbalancer.size
  algorithm        = "round_robin"
  alert_email      = var.alert_email
  domain           = local.domain
}

# # ---------------------------------------------------------------------------------------------------------------------#
# Create managed services [mysql | redis]
# # ---------------------------------------------------------------------------------------------------------------------#
module "database" {
  source          = "./modules/database"
  database        = var.database
  project         = local.project
  region          = var.region
  vpc_uuid        = module.network.vpc_uuid
  vpc_cidr        = var.vpc_cidr
}
  
# # ---------------------------------------------------------------------------------------------------------------------#
# Create kubernetes cluster
# # ---------------------------------------------------------------------------------------------------------------------#
module "kubernetes" {
  source             = "./modules/kubernetes"
  kubernetes_version = local.kubernetes_version
  kubernetes         = var.kubernetes
  project            = local.project
  region             = var.region
  vpc_uuid           = module.network.vpc_uuid
  domain             = local.domain
  timezone           = var.timezone
  brand              = var.brand
  dockerhub          = var.dockerhub
}
  
