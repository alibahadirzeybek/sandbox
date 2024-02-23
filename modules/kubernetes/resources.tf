resource "docker_image" "images" {
    for_each        = fileset(path.root, "${path.module}/images/*/Dockerfile")
    name            = "local.ververica.registry/v2.12/${reverse(split("/", each.value))[1]}:2.12.1"
    keep_locally    = true
    build {
        context     = substr(each.value, 0, length(each.value) - 11)
    }
    triggers = {
        dir_sha1    = sha1(join("", [for f in fileset(path.root, "${substr(each.value, 0, length(each.value) - 11)}/*") : filesha1(f)]))
    }
}

resource "kubectl_manifest" "manifests" {
    for_each        = fileset(path.root, "${path.module}/manifests/*/*.yaml")
    yaml_body       = templatefile(
        each.value,
        {
            access_key = var.access_key
            secret_key = var.secret_key
            cluster_ip = var.cluster_ip
        }
    )
    depends_on      = [docker_image.images]
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
    dynamic "set" {
        for_each = { for key, value in each.value.values: key => value }
        content {
            name  = set.value["name"]
            value = set.value["value"]
        }
    }
}
