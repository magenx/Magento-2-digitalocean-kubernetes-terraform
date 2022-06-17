
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = ">= 2.20.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.1"
    }
  }
}

provider "digitalocean" {}

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
  
