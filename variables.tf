
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
    node_pool = {
      min_nodes  = "1"
      max_nodes  = "2"
      size       = "s-1vcpu-2gb-intel"
    }
    app_node_pool = {
      min_nodes  = "1"
      max_nodes  = "2"
      size       = "s-1vcpu-2gb-intel"
    }
    elasticsearch = {
      node_count = "1"
      size       = "s-1vcpu-2gb-intel"
    }
  }
 }

variable "dockerhub" {
  default = ""
}

variable "docker_image" {
  default = {
    elasticsearch = {
      build_arg  = {
        ELASTICSEARCH_VERSION = "7.17.4"
      }
    }
    php = {
      build_arg  = {
        ALPINE_VERSION = "3.16.0"
      }
    }
    nginx = {
      build_arg  = {
        ALPINE_VERSION = "3.16.0"
      }
    }
    magento = {
      build_arg  = {
        ALPINE_VERSION = "3.16.0"
      }
    }
  }
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


