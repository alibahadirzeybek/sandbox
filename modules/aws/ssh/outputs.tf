output "key_name" {
  value = aws_key_pair.vvp.key_name
}

output "private_key_pem" {
  value = tls_private_key.vvp.private_key_pem
}
