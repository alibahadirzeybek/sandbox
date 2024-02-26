resource "aws_s3_bucket" "vvp" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_object" "objects" {
  for_each      = fileset("${path.module}/objects", "*/*")
  bucket        = aws_s3_bucket.vvp.id
  key           = each.value
  content       = templatefile("${path.module}/objects/${each.value}", { bucket_name = var.bucket_name })
}
