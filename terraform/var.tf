variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "backend_bucket_name" {
  description = "S3 bucket for storing Terraform backend state"
}

variable "backend_bucket_region" {
  description = "AWS region for the backend S3 bucket"
  default     = "us-east-1"
}

variable "backend_lock_table" {
  description = "DynamoDB table for state locking"
}

variable "domain_name" {
  description = "Domain name for Route 53 hosted zone"
}

variable "aws_region" {
  description = "AWS region for resource deployment"
  default     = "us-east-1"
}

variable "kms_alias" {
  description = "Alias name for the KMS key"
  default     = "my-key-alias"
}

variable "geo_restrictions" {
  description = "List of allowed geographic locations for CloudFront"
  type        = list(string)
}
