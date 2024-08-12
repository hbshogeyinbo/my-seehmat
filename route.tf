# route53.tf

# Route 53 Hosted Zone
resource "aws_route53_zone" "seehmat_zone" {
  name = "seehmat.com"
}

# Fetch ACM Certificate ARN dynamically
data "aws_acm_certificate" "seehmat_cert" {
  domain   = "seehmat.com"
  statuses = ["ISSUED"]
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

# Output the certificate ARN for reference
output "certificate_arn" {
  value = data.aws_acm_certificate.seehmat_cert.arn
}
