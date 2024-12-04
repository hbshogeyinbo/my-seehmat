# providers.tf

provider "aws" {
  alias  = "eu"
  region = var.aws_region
}

provider "aws" {
  alias  = "us"
  region = var.aws_us_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}