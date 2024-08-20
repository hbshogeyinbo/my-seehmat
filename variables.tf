# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "aws_us_region" {
  description = "The AWS region for US services (like ACM and KMS)"
  type        = string
  default     = "us-east-1"
}

variable "website_bucket_name" {
  description = "Name of the S3 bucket to store website content"
  type        = string
  default     = "seehmatbuck"
}

variable "logs_bucket_name" {
  description = "Name of the S3 bucket to store CloudFront logs"
  type        = string
  default     = "seehmatbuck-logs"
}

variable "domain_name" {
  description = "Domain name for the website"
  type        = string
  default     = "seehmat.com"
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for cache invalidation"
  type        = string
  default     = "EV9MAO6142ML1"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
  default     = "arn:aws:acm:us-east-1:992382451794:certificate/6a065cea-4cfc-49f7-b67a-f819d45eb911"
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for DNSSEC"
  type        = string
  default     = "arn:aws:kms:us-east-1:992382451794:key/e7bb1940-d5a7-4eca-a703-e0c974a8e95b"
}

variable "route53_zone_id" {
  description = "ID of the Route 53 hosted zone"
  type        = string
  default     = "Z07220353IK3RJW6WSF5Q"
}

variable "origin_access_control_id" {
  description = "ID of the CloudFront origin access control"
  type        = string
  default     = "E1XME0UN9TPSRZ"
}
