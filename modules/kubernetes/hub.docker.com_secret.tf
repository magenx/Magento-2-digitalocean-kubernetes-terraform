


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
        "${var.registry_server}" = {
          "username" = var.registry_username
          "password" = var.registry_password
          "email"    = var.registry_email
          "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }
}

