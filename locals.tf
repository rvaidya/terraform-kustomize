locals {
  template_string = file("${path.module}/templates/${var.kubernetes_platform}/kubeconfig.tpl")

  # transformed_vars = {
  #   for key in keys(var.template_vars):
  #   "_${key}" => var.template_vars[key]
  # }
}