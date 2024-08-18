# route53.tf

# Define a variable for the domain name
variable "domain_name" {
  description = "The domain name for which to fetch the ACM certificate."
  type        = string
  default     = "seehmat.com"  # Adjust as necessary
}

# Route 53 Hosted Zone
resource "aws_route53_zone" "seehmat_zone" {
  name = "seehmat.com"
}
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Fetch ACM Certificate ARN dynamically
data "aws_acm_certificate" "seehmat_cert" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
  most_recent = true
  provider  = aws.us_east_1
  
}

# Route 53 A Record (Alias) for Root Domain
resource "aws_route53_record" "root_domain" {
  zone_id = aws_route53_zone.seehmat_zone.zone_id
  name    = "seehmat.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route 53 CNAME Record for www Subdomain
resource "aws_route53_record" "www_subdomain" {
  zone_id = aws_route53_zone.seehmat_zone.zone_id
  name    = "www.seehmat.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
}

