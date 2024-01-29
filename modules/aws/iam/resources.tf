resource "aws_iam_user" "vvp" {
  name              = var.user_name
}

resource "aws_iam_policy" "vvp" {
  name              = var.policy_name
  policy            = jsonencode({
  Version           = "2012-10-17"
  
  Statement = [
      {
        Action      = ["s3:*"]
        Effect      = "Allow"
        Resource    = [var.bucket_arn]
      },
      {
        Action      = ["s3:*"]
        Effect      = "Allow"
        Resource    = ["${var.bucket_arn}/*"]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "vvp" {
  user              = aws_iam_user.vvp.name
  policy_arn        = aws_iam_policy.vvp.arn
}

resource "aws_iam_access_key" "vvp" {
  user              = aws_iam_user.vvp.name
}
