locals {
    helm_releases           = flatten([
        {
            name            = "vvp"
            namespace       = "vvp"
            repository      = "https://charts.ververica.com"
            chart           = "ververica-platform"
            version         = "5.8.0"
            values          = flatten([
                {
                    name    = "vvp.blobStorage.baseUri"
                    value   = "s3://${var.bucket_name}"
                },
                {
                    name    = "blobStorageCredentials.s3.accessKeyId"
                    value   = var.access_key
                },
                {
                    name    = "blobStorageCredentials.s3.secretAccessKey"
                    value   = var.secret_key
                }
            ])
        }
    ])
}
