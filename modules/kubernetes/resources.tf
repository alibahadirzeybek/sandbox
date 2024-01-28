resource "kubectl_manifest" "manifests" {
    for_each        = fileset(path.root, "${path.module}/manifests/*/*.yaml")
    yaml_body       = file(each.value)
}

resource "helm_release" "releases" {
    for_each        = { for key, value in local.helm_releases: key => value }
    name            = each.value.name
    namespace       = each.value.namespace
    repository      = each.value.repository
    chart           = each.value.chart
    version         = each.value.version
    values          = [file("${path.module}/releases/${each.value.name}/values.yaml")]
    depends_on      = [kubectl_manifest.manifests]
}