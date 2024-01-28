locals {
    helm_releases           = flatten([
        {
            name            = "minio"
            namespace       = "minio"
            repository      = "https://charts.helm.sh/stable"
            chart           = "minio"
            version         = "5.0.33"
        },
        {
            name            = "vvp"
            namespace       = "vvp"
            repository      = "https://charts.ververica.com"
            chart           = "ververica-platform"
            version         = "5.8.0"
        }
    ])
}