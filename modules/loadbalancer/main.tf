


////////////////////////////////////////////////////////[ LOAD BALANCER ]/////////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create certificate for load balancer
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_certificate" "this" {
  name    = "${var.project.name}-${var.domain}"
  type    = "lets_encrypt"
  domains = [var.domain]

  lifecycle {
    create_before_destroy = true
  }
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create load balancer
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_loadbalancer" "this" {
  name                   = "${var.project.name}-loadbalancer"
  region                 = var.region
  vpc_uuid               = var.vpc_uuid
  size                   = var.size
  algorithm              = var.algorithm

  enable_proxy_protocol  = true
  redirect_http_to_https = true
  
  forwarding_rule {
    entry_port     = 443
    entry_protocol = "http2"

    target_port     = 80
    target_protocol = "http"

    certificate_name = digitalocean_certificate.this.name
  }

  healthcheck {
    protocol                 = "tcp"
    port                     = 80
    check_interval_seconds   = 10
    response_timeout_seconds = 5
    unhealthy_threshold      = 3
    healthy_threshold        = 5
  }
  
  droplet_tag = "loadbalancer"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Assign loadbalancer to this project per environment
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_project_resources" "loadbalancer" {
  project   = var.project.id
  resources = [
    digitalocean_loadbalancer.this.urn
  ]
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Assign loadbalancer to kubernetes control
# # ---------------------------------------------------------------------------------------------------------------------#
resource "helm_release" "nginx_ingress" {
  name       = "${var.project.name}"
  
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "service.annotations.kubernetes\\.digitalocean\\.com/load-balancer-id"
    value = digitalocean_loadbalancer.this.id
  }
}

