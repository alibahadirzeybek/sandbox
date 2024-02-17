module "s3" {
    source              = "./s3"
    bucket_name         = local.unique_name
}

module "iam" {
    source              = "./iam"
    user_name           = local.unique_name
    policy_name         = local.unique_name
    bucket_arn          = module.s3.bucket_arn
}

module "ssh" {
    source              = "./ssh"
    key_name            = local.unique_name
}

module "vpc" {
    source              = "./vpc"
    name                = local.unique_name
}

module "emr" {
    source              = "./emr"
    name                = local.unique_name
    subnet_id           = module.vpc.subnet_id
    security_group_id   = module.vpc.security_group_id
    key_name            = module.ssh.key_name
    private_key_pem     = module.ssh.private_key_pem
    bucket_name         = module.s3.bucket_name 
}
