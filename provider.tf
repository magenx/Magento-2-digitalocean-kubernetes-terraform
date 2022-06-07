
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.16.0"
    }
  }
}

provider "digitalocean" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

data "digitalocean_kubernetes_cluster" "magento" {
  depends_on = [module.kubernetes.cluster_id]
  name       = "${local.project.name}-magento-cluster"
}

provider "kubernetes" {
  host    = data.digitalocean_kubernetes_cluster.magento.endpoint
  token   = data.digitalocean_kubernetes_cluster.magento.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.magento.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = data.digitalocean_kubernetes_cluster.magento.endpoint
    token = data.digitalocean_kubernetes_cluster.magento.kube_config[0].token
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.magento.kube_config[0].cluster_ca_certificate
    )
  }
}

  
