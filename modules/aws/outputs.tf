output "bucket_name" {
  value = module.s3.bucket_name
}

output "access_key" {
  value = module.iam.access_key
}

output "secret_key" {
  value = module.iam.secret_key
}

output "cluster_ip" {
  value = module.emr.cluster_ip
}
