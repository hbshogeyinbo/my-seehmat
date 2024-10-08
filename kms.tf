# kms.tf

# provider "aws" {
#   alias  = "us"
#   region = var.aws_us_region
# }

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "dnssec_key" {  
  provider                = aws.us
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
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
          "kms:Sign"
        ],
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
          },
          "ArnLike": {
            "aws:SourceArn": "arn:aws:route53:::hostedzone/*"
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

resource "aws_route53_key_signing_key" "seehmat_ksk" {
  hosted_zone_id             = var.route53_zone_id  # Reference the existing zone from route53.tf
  key_management_service_arn = aws_kms_key.dnssec_key.arn  
  name                       = "seehmat-ksk"  
}

resource "aws_route53_hosted_zone_dnssec" "seehmat_dnssec" {  
  depends_on = [
    aws_route53_key_signing_key.seehmat_ksk  
  ]
  hosted_zone_id = aws_route53_key_signing_key.seehmat_ksk.hosted_zone_id
}
