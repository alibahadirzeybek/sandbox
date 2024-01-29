output "bucket_name" {
    value       = module.aws.bucket_name
}

output "access_key" {
    value       = module.aws.access_key
}

output "secret_key" {
    value       = module.aws.secret_key
    sensitive   = true
}
