terraform {
  backend "s3" {
    bucket         = "seehmat-terraform-state-bucket"
    key            = "terraform/state/${var.environment}/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "seehmat-terraform-lock-table"
    encrypt        = true
  }
}
