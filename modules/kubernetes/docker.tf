


/////////////////////////////////////////////////////[ DOCKER BUILD AND PUSH ]////////////////////////////////////////////
# # ---------------------------------------------------------------------------------------------------------------------#
# Build docker image per config
# # ---------------------------------------------------------------------------------------------------------------------#
resource "docker_image" "this" {
  for_each     = var.docker_image
  name         = each.key
  force_remove = true
  build {
    path       = "${path.module}/docker/${each.key}"
    tag        = ["${var.dockerhub}/${each.key}:latest"]
    no_cache   = true
    
    build_arg  = var.docker_image[each.key].build_arg
    
    label      = {
      author : "${var.brand}"
    }
    
  }
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Push docker image to registry if updated
# # ---------------------------------------------------------------------------------------------------------------------#
resource "null_resource" "docker_push" {
  for_each = var.docker_image
  
  triggers = {
    docker = docker_image.this[each.key].latest
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = <<-EOT
        echo "${DOCKERHUB_PASSWORD}" | docker login --username "${DOCKERHUB_USERNAME}" --password-stdin
        docker push "${var.dockerhub}/${each.key}:latest"
      EOT
  }
}

