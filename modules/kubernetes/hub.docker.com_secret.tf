


/////////////////////////////////////////////////////[ DOCKER REGISTRY SECRET ]///////////////////////////////////////////
# # ---------------------------------------------------------------------------------------------------------------------#
# Create docker hub registry auth secret
# # ---------------------------------------------------------------------------------------------------------------------#
resource "kubernetes_secret" "hubdockercom" {
  metadata {
    name = "hubdockercom"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.docker_registry.server}" = {
          "username" = var.docker_registry.username
          "password" = var.docker_registry.password
          "email"    = var.docker_registry.email
          "auth"     = base64encode("${var.docker_registry.username}:${var.docker_registry.password}")
        }
      }
    })
  }
}

