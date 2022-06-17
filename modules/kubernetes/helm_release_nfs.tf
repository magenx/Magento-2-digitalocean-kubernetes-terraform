


////////////////////////////////////////////////////////[ NFS PROVISIONER ]///////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create nfs cluster provisioner
# # ---------------------------------------------------------------------------------------------------------------------#
resource "helm_release" "nfs" {
  name       = "${var.project.name}-nfs"
  repository = "https://openebs.github.io/charts"
  chart      = "openebs"
  set {
    name  = "nfs-provisioner.enabled"
    value = "true"
  }
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create nfs storage class
# # ---------------------------------------------------------------------------------------------------------------------#
resource "kubernetes_storage_class" "nfs" {
  metadata {
    name        = "openebs-rwx"
    annotations = {
      "openebs.io/cas-type" = "nfsrwx"
      "cas.openebs.io/config" = {
        "NFSServerType" = "kernel"
        "BackendStorageClass" = "openebs-hostpath"
     }
    }
  }
  storage_provisioner = "openebs.io/nfsrwx"
  reclaim_policy      = "Retain"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create nfs volume claim
# # ---------------------------------------------------------------------------------------------------------------------#
resource "kubernetes_persistent_volume_claim" "nfs" {
  metadata {
    name = "${var.project.name}-nfs"
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "openebs-rwx"
    resources {
      requests = {
        storage = "100G"
      }
    }
  }
}
  
