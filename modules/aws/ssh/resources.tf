resource "tls_private_key" "vvp" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

resource "aws_key_pair" "vvp" {
  key_name    = var.key_name
  public_key  = tls_private_key.vvp.public_key_openssh
}
