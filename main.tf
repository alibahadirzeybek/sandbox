module "aws" {
    source      = "./modules/aws"
}

module "kubernetes" {
    source      = "./modules/kubernetes"
    bucket_name = module.aws.bucket_name
    access_key  = module.aws.access_key
    secret_key  = module.aws.secret_key
    cluster_ip  = module.aws.cluster_ip
}
