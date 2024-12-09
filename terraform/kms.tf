data "aws_caller_identity" "current" {}

resource "aws_kms_key" "dnssec_key" {
  description             = "KMS key for DNSSEC signing"
  deletion_window_in_days = 10
  key_usage               = "SIGN_VERIFY"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "kms:*",
        Resource = "*"
      }
    ]
  })
}