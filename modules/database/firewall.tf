


////////////////////////////////////////////////////[ DATABASE TRUSTED SOURCES ]//////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create managed database services [ mysql | redis ] trusted sources firewall
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_database_firewall" "this" {
  for_each   = digitalocean_database_cluster.this
  cluster_id = each.value.id

  rule {
    type  = "tag"
    value = "database"
  }
}

