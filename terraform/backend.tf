terraform {
  backend "s3" {
    bucket         = var.backend_bucket_name        # S3 bucket for storing state
    key            = "terraform/state/${var.environment}/terraform.tfstate" # Key path for state
    region         = var.backend_bucket_region      # AWS region
    encrypt        = true                           # Encrypt state file
    dynamodb_table = var.backend_lock_table         # DynamoDB table for state locking
  }
}
