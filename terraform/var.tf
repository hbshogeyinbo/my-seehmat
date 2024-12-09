variable "environment" {
  default = "dev"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "logs_bucket_name" {
  description = "Name of the logs S3 bucket"
}

variable "domain_name" {
  description = "Domain name for the application"
}

variable "acm_certificate_arn" {
  description = "ACM Certificate ARN for CloudFront"
}
