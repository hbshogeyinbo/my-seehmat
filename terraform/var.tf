# variables.tf.example

# AWS Region for deployment
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"  # Replace with your preferred AWS region
}

variable "aws_us_region" {
  description = "The AWS region for US services (like ACM and KMS)"
  type        = string
  default     = "us-east-1"  # Replace with your preferred AWS region
}

# S3 Bucket Names
variable "website_bucket_name" {
  description = "Name of the S3 bucket to store website content"
  type        = string
  default     = "your-bucket-name"  # Replace with your actual bucket name
}

variable "logs_bucket_name" {
  description = "Name of the S3 bucket to store CloudFront logs"
  type        = string
  default     = "your-logs-bucket-name"  # Replace with your actual logs bucket name
}

# Domain Name
variable "domain_name" {
  description = "Domain name for the website"
  type        = string
  default     = "example.com"  # Replace with your actual domain name
}

# CloudFront Distribution ID
variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for cache invalidation"
  type        = string
  default     = ""  # Placeholder for CloudFront Distribution ID
}

# ACM Certificate ARN
variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
  default     = ""  # Placeholder for ACM Certificate ARN
}

# KMS Key ARN for DNSSEC
variable "kms_key_arn" {
  description = "ARN of the KMS key used for DNSSEC"
  type        = string
  default     = ""  # Placeholder for KMS Key ARN
}

# Route 53 Zone ID
variable "route53_zone_id" {
  description = "ID of the Route 53 hosted zone"
  type        = string
  default     = ""  # Placeholder for Route 53 Zone ID
}

# Origin Access Control ID
variable "origin_access_control_id" {
  description = "ID of the CloudFront origin access control"
  type        = string
  default     = ""  # Placeholder for Origin Access Control ID
}
