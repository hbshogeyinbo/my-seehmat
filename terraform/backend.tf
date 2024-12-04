terraform {
  backend "s3" {
    bucket         = "seehmat-terraform-state-bucket"
    key            = "terraform/state/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "seehmat-terraform-lock-table"
    encrypt        = true
  }
}
