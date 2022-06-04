


//////////////////////////////////////////////////////[ KUBERNETES CLUSTER ]//////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create kubernetes cluster
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_kubernetes_cluster" "magento" {
  name     = "${var.project.name}-magento-cluster"
  region   = var.region
  vpc_uuid = var.vpc_uuid
  version  = var.kubernetes_version

  node_pool {
    name       = "${var.project.name}-pool-frontend"
    size       = var.kubernetes.node_pool.size
    auto_scale = true
    min_nodes  = var.kubernetes.node_pool.min_nodes
    max_nodes  = var.kubernetes.node_pool.max_nodes
    labels = {
      service  = "magento"
      priority = "high"
    }
    tags       = ["${var.project.name}-pool-frontend"]
  }
  
  tags         = ["${var.project.name}-magento-cluster"]
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create node pool for elasticsearch
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_kubernetes_node_pool" "elasticsearch" {
  cluster_id = digitalocean_kubernetes_cluster.magento.id

  name       = "${var.project.name}-elasticsearch"
  size       = var.kubernetes.elasticsearch.size
  node_count = var.kubernetes.elasticsearch.node_count
  
  labels = {
    service  = "elasticsearch"
    priority = "high"
  }
  
  tags       = ["${var.project.name}-elasticsearch"]
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Assign kubernetes cluster to this project
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_project_resources" "kubernetes" {
  project   = var.project.id
  resources = [digitalocean_kubernetes_cluster.magento.urn]
}

