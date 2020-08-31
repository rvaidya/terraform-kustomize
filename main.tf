
data "template_file" "kubeconfig" {
  template = local.template_string

  vars = var.kube_config
}

provider "kustomization" {
  kubeconfig_raw = data.template_file.kubeconfig.rendered
}

data "kustomization" "current" {
  # path to kustomization directory
  path = var.manifest_path
}

data "template_file" "current_overlay" {
  for_each = data.kustomization.current.ids
  template = replace(replace(
    data.kustomization.current.manifests[each.value], "/\\$\\{([^_][^}]*)\\}/", "$$$${$1}"
  ), "/%\\{([^}]*)}/", "%%%{$1}")

  vars = var.template_vars
}

resource "kustomization_resource" "current" {
  skip_dry_run = var.skip_dry_run
  for_each     = data.kustomization.current.ids
  manifest     = data.template_file.current_overlay[each.value].rendered
}
