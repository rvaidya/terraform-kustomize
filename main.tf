provider "kustomization" {
  kubeconfig_raw = templatefile("${path.module}/templates/${var.kubernetes_platform}/kubeconfig.tpl", var.kube_config)
}

data "kustomization_build" "current" {
  # path to kustomization directory
  path = var.manifest_path
}

data "template_file" "current_overlay" {
  for_each = data.kustomization_build.current.ids

  # Since kustomize templates can include configmaps with embedded bash scripts, we cannot replace
  # all ${VAR} template expressions, because this overlaps with bash's own variable expression.
  # Instead, we escape all template expressions where the variable name is not prefixed by an underscore.
  # ex: ${VARNAME} - treat as a bash variable and escape it
  # ex: ${_VARNAME} - treat as a terraform template variable, do not escape it, the var will be substituted
  template = replace(replace(
    data.kustomization_build.current.manifests[each.value], "/\\$\\{([^_][^}]*)\\}/", "$$$${$1}"
  ), "/%\\{([^}]*)}/", "%%%{$1}")

  vars = var.template_vars
}

resource "kustomization_resource" "current" {
  for_each = data.kustomization_build.current.ids
  manifest = data.template_file.current_overlay[each.value].rendered
}
