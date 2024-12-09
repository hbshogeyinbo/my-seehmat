# variables.tf.example
# AWS Region for deployment
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
variable "aws_us_region" {
  description = "The AWS region for US services (like ACM and KMS)"
  type        = string
}
# S3 Bucket Names
variable "website_bucket_name" {
  description = "Name of the S3 bucket to store website content"
  type        = string
}
variable "logs_bucket_name" {
  description = "Name of the S3 bucket to store CloudFront logs"
  type        = string
}
# Domain Name
# # variables.tf.example
# # AWS Region for deployment
# variable "aws_region" {
#   description = "The AWS region to deploy resources in"
#   type        = string
# }
# variable "aws_us_region" {
#   description = "The AWS region for US services (like ACM and KMS)"
#   type        = string
# }
# # S3 Bucket Names
# variable "website_bucket_name" {
#   description = "Name of the S3 bucket to store website content"
#   type        = string
# }
# variable "logs_bucket_name" {
#   description = "Name of the S3 bucket to store CloudFront logs"
#   type        = string
# }
# # Domain Name
# variable "domain_name" {
#   description = "Domain name for the website"
#   type        = string
# }
# # CloudFront Distribution ID
# variable "cloudfront_distribution_id" {
#   description = "CloudFront distribution ID for cache invalidation"
#   type        = string
# }
# # KMS Key ARN for DNSSEC
# variable "kms_key_arn" {
#   description = "ARN of the KMS key used for DNSSEC"
#   type        = string
# }
# # Route 53 Zone ID
# variable "route53_zone_id" {
#   description = "ID of the Route 53 hosted zone"
#   type        = string
# }
# # Origin Access Control ID
# variable "origin_access_control_id" {
#   description = "ID of the CloudFront origin access control"
#   type        = string
# }
variable "domain_name" {
  description = "Domain name for the website"
  type        = string
}
# CloudFront Distribution ID
variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for cache invalidation"
  type        = string
}
# ACM Certificate ARN
variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
}
# KMS Key ARN for DNSSEC
variable "kms_key_arn" {
  description = "ARN of the KMS key used for DNSSEC"
  type        = string
}
# Route 53 Zone ID
variable "route53_zone_id" {
  description = "ID of the Route 53 hosted zone"
  type        = string
}
# Origin Access Control ID
variable "origin_access_control_id" {
  description = "ID of the CloudFront origin access control"
  type        = string
}
  default     = "seehmat.com" # Replace with your actual domain
}