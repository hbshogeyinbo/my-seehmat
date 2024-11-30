# Fetch AWS account details
data "aws_caller_identity" "current" {}

# Fetch Route 53 hosted zone dynamically
data "aws_route53_zone" "selected" {
   zone_id = var.route53_zone_id
}

# Create a KMS key for DNSSEC
resource "aws_kms_key" "dnssec_key" {
  # Ensure the provider matches the correct region
  provider                = aws.us
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"

  # Policy for the KMS key
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "dnssec-policy",
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
            "aws:SourceArn": "arn:aws:route53:::hostedzone/${data.aws_route53_zone.selected.id}"
          }
        }
      },
      {
        "Sid": "Allow Route 53 DNSSEC to CreateGrant",
        "Effect": "Allow",
        "Principal": {
          "Service": "dnssec-route53.amazonaws.com"
        },
        "Action": [
          "kms:CreateGrant"
        ],
        "Resource": "*",
        "Condition": {
          "Bool": {
            "kms:GrantIsForAWSResource": true
          }
        }
      }
    ]
  })
}

# Route 53 Key Signing Key
resource "aws_route53_key_signing_key" "seehmat_ksk" {
  hosted_zone_id             = var.route53_zone_id
  key_management_service_arn = aws_kms_key.dnssec_key.arn
  name                       = "seehmat-ksk"
}

# Enable DNSSEC for the hosted zone
resource "aws_route53_hosted_zone_dnssec" "seehmat_dnssec" {
  depends_on     = [aws_route53_key_signing_key.seehmat_ksk]
  hosted_zone_id = var.route53_zone_id
}



