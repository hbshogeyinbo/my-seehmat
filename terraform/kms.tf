
# Fetch AWS Account Information
data "aws_caller_identity" "current" {}

# Create a Route 53 Hosted Zone (in your default region)
data "aws_route53_zone" "existing_zone" {
  id = var.hosted_zone_id
}

# Create KMS Key for DNSSEC (must be in us-east-1)
resource "aws_kms_key" "dnssec_key" {
  provider                = aws.us
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Allow administration of the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "Allow Route 53 DNSSEC Service",
        "Effect": "Allow",
        "Principal": {
          "Service": "dnssec-route53.amazonaws.com"
        },
        "Action": [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
          "kms:CreateGrant"
        ],
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
          },
          "ArnLike": {
            "aws:SourceArn": "arn:aws:route53:::hostedzone/${data.aws_route53_zone.existing_zone.id}"
          }
        }
      }
    ]
  })
}

# Create Key Signing Key (KSK) in the hosted zone
resource "aws_route53_key_signing_key" "ksk" {
  hosted_zone_id             = data.aws_route53_zone.existing_zone.id
  key_management_service_arn = aws_kms_key.dnssec_key.arn
  name                       = "${var.domain_name}-ksk"
}

# Enable DNSSEC for the hosted zone
resource "aws_route53_hosted_zone_dnssec" "dnssec" {
  depends_on     = [aws_route53_key_signing_key.ksk]
  hosted_zone_id = data.aws_route53_zone.existing_zone.id
}
