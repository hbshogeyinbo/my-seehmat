# providers.tf

provider "aws" {
  alias  = "eu"
  region = var.aws_region
}

provider "aws" {
  alias  = "us"
  region = var.aws_us_region
}