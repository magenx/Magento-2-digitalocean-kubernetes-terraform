
variable "region" {
  ## https://docs.digitalocean.com/products/platform/availability-matrix/
  description  = "Default region to deploy infrastructure"
  default = "fra1"
}

variable "timezone" {
  description  = "Default timezone to deploy infrastructure"
  default = "Europe/Berlin"
}

variable "vpc_cidr" {
  description  = "VPC cidr network size"
  default = "10.35.0.0/16"
}

variable "domains" {
  description  = "Domains map per environment production | development"
  default      = {
    production  = "magento.com"
    development = "magento.net"
  }
}

variable "alert_email" {
  description  = "Send monitoring alerts to this email"
  default      = "alert@magento.com"
}

variable "admin_email" {
  description  = "Send magento related messages to this email"
  default      = "admin@magento.com"
}

variable "default_image" {
  description  = "Create services droplets and packer build from this base default official image"
  default = "debian-11-x64"
}

variable "loadbalancer" {
  description = "Load balancer size lb-small, lb-medium, or lb-large"
  default     = {
    size      = "lb-small"
  }
}

variable "kubernetes" {
  default = {
    php = {
      min_nodes  = "1"
      max_nodes  = "2"
      size       = "s-1vcpu-2gb-intel"
      port       = "9000"
      replicas   = "2"
      max_memory = "756M"
      max_cpu    = null
      min_memory = "128M"
      min_cpu    = "1"
    }
    magento = {
      min_nodes  = "1"
      max_nodes  = "2"
      size       = "s-1vcpu-2gb-intel"
      port       = "80"
      replicas   = "2"
      max_memory = null
      max_cpu    = null
      min_memory = "756M"
      min_cpu    = "1"
    }
    nginx = {
      min_nodes  = "1"
      max_nodes  = "2"
      size       = "s-1vcpu-2gb-intel"
      port       = "80"
      replicas   = "2"
      max_memory = "512M"
      max_cpu    = null
      min_memory = "128M"
      min_cpu    = "750m"
    }
    elasticsearch = {
      node_count = "1"
      size       = "s-1vcpu-2gb-intel"
      port       = "9200"
      replicas   = "2"
      max_memory = null
      max_cpu    = null
      min_memory = "512M"
      min_cpu    = "1"
    }
    varnish = {
      min_nodes  = "1"
      max_nodes  = "2"
      size       = "s-1vcpu-2gb-intel"
      port       = "8081"
      replicas   = "2"
      max_memory = null
      max_cpu    = null
      min_memory = "512M"
      min_cpu    = "1"
    }
  }
 }

variable "dockerhub" {
  description = "Docker Hub registry account name"
  default     = ""
}

variable "database" {
  default = {
    mysql = {
      version    = "8"
      node_count = "1"
      size       = "db-s-1vcpu-1gb"
    }
    redis = {
      version    = "6"
      node_count = "1"
      size       = "db-s-1vcpu-1gb"
    }
  }
 }


