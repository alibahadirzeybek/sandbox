output "access_key" {
  value       = aws_iam_access_key.vvp.id
}

output "secret_key" {
  sensitive   = true
  value       = aws_iam_access_key.vvp.secret
}
