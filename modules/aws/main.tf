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
