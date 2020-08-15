variable "kubernetes_platform" {
  type        = string
  description = "Kubeconfig platform (gke, eks, aks)"
}

variable "kube_config" {
  type        = map(string)
  description = "Kubeconfig variables"
}

variable "manifest_path" {
  type        = string
  description = "Path to Kustomize overlay to build."
}

# All variable names need to be prefixed with underscores
variable "template_vars" {
  type        = map(any)
  description = "A list of variables to inject into the template"
  default = {}
}
