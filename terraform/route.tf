# route.tf

# provider "aws" {
#   alias  = "eu"
#   region = var.aws_region
# }

# provider "aws" {
#   alias  = "us"
#   region = var.aws_us_region
# }


data "aws_route53_zone" "selected" {
  name = var.domain_name
}

data "aws_acm_certificate" "seehmat_cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
  provider    = aws.us
  key_types   = ["RSA_2048"]
}

resource "aws_route53_record" "root_domain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_subdomain" {
  zone_id = aws_route53_zone.seehmat_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
}
