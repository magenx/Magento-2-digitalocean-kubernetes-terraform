
variable "project" {
  description  = "The data of the project"
  type         = object({
    created_at   = string
    description  = string
    environment  = string
    id           = string
    is_default   = bool
    name         = string
    owner_id     = number
    owner_uuid   = string
    purpose      = string
    resources    = set(string)
    updated_at   = string 
})
}

variable "kubernetes_version" {
  description = "Get the latest version for kubernetes"
  type        = string
}

variable "kubernetes" {
  description  = "Kubernetes cluster configuration parameters"
  type         = map
}

variable "region" {
  description  = "Region for this project and environment"
  type         = string
}

variable "vpc_uuid" {
  description = "UUID of vpc for this project and environment"
  type        = string
}
