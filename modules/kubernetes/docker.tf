


/////////////////////////////////////////////////////[ DOCKER BUILD AND PUSH ]////////////////////////////////////////////
# # ---------------------------------------------------------------------------------------------------------------------#
# Build docker image per config and push to registry
# # ---------------------------------------------------------------------------------------------------------------------#
resource "docker_image_registry" "this" {
  for_each     = var.kubernetes
  name         = "${var.dockerhub}/${each.key}:latest"

  build {
    #remote_context  = ""
    #suppress_output = true
    
    force_remove = true
    context      = "${path.module}/docker/${each.key}"
    no_cache     = true
    
    build_args   = {
      BRAND      = "${var.brand}"
      DOMAIN     = "${var.domain}"
      TIMEZONE   = "${var.timezone}"
    }
    
    labels      = {
      author    = "${var.brand}"
    }
    
  }
}

