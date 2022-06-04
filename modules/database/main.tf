


////////////////////////////////////////////////////////[ DATABASE SERVICES ]/////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create managed database services [ mysql | redis ]
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_database_cluster" "this" {
  for_each   = var.database
  name       = "${var.project.name}-${each.key}"
  engine     = each.key
  version    = each.value.version
  size       = each.value.size
  region     = var.region
  node_count = each.value.node_count
  private_network_uuid = var.vpc_uuid
  eviction_policy      = each.key == "redis" ? "allkeys_lru" : null
  tags                 = [digitalocean_tag.database[each.key].id]
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create tag for managed database services
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_tag" "database" {
  for_each = var.database
  name     = "${var.project.name}-${each.key}"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Assign managed database services to this project
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_project_resources" "database" {
  project   = var.project.id
  resources = values(digitalocean_database_cluster.this)[*].urn
}

