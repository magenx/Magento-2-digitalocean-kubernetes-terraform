
locals {

  manager_ssh_key = data.digitalocean_ssh_keys.manager.ssh_keys[0]
  admin_ssh_key   = data.digitalocean_ssh_keys.admin.ssh_keys[0]
  
  kubernetes_version = data.digitalocean_kubernetes_versions.get.latest_version
  
  domain          = var.domains[local.environment]
  
}
