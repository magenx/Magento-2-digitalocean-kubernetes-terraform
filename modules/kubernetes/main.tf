


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
resource "digitalocean_kubernetes_node_pool" "this" {
  for_each   = var.kubernetes
  cluster_id = digitalocean_kubernetes_cluster.magento.id

  name       = "${var.project.name}-${each.key}"
  size       = each.value.size
  auto_scale = true
  min_nodes  = each.value.min_nodes
  max_nodes  = each.value.max_nodes
  
  labels = {
    service  = each.key
    priority = "high"
  }
  
  tags       = ["${var.project.name}-${each.key}"]
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Assign kubernetes cluster to this project
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_project_resources" "kubernetes" {
  project   = var.project.id
  resources = [digitalocean_kubernetes_cluster.magento.urn]
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Deploy docker image to kubernetes cluster
# # ---------------------------------------------------------------------------------------------------------------------#
resource "kubernetes_deployment" "this" {
  for_each = var.kubernetes
  metadata {
    name = "${var.project.name}-${each.key}"
  }
  spec {
    replicas = each.value.replicas
    selector {
      match_labels = {
        app = "${var.project.name}-${each.key}"
      }
    }
    template {
      metadata {
        labels = {
          app  = "${var.project.name}-${each.key}"
        }
      }
      spec {
        hostname      = each.key
        node_selector = {
          "doks.digitalocean.com/node-pool" = each.key
        }
        restart_policy                   = "Always"
        share_process_namespace          = false
        termination_grace_period_seconds = 30
		
        container {
          image = "${var.dockerhub}/${each.key}"
          name  = each.key
          port {
            container_port = each.value.port
          }
          resources {
            limits = {
              memory = each.value.memroy_max
              cpu    = each.value.cpu_max
            }
            requests = {
              memory = each.value.memroy_min
              cpu    = each.value.cpu_min
            }
          }
        }
      }
    }
  }
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Deploy docker image to kubernetes cluster
# # ---------------------------------------------------------------------------------------------------------------------#
resource "kubernetes_service" "this" {
  for_each   = var.kubernetes
  metadata {
    name     = "${var.project.name}-${each.key}"
  }
  spec {
    selector = {
      app    = "${var.project.name}-${each.key}"
    }
    port {
      port   = each.value.port
    }
  }
}


