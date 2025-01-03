# Automatically find or create an ACM certificate
resource "aws_acm_certificate" "seehmat_cert" {
  provider = aws.us
  domain_name       = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = [
    var.domain_name,
    "www.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# DNS Validation Records for ACM Certificate
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.seehmat_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.seehmat_new.id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 300
}

# Root Domain Record (A Record)
resource "aws_route53_record" "root_domain" {
  zone_id = aws_route53_zone.seehmat_new.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Subdomain Record (CNAME Record for www)
resource "aws_route53_record" "www_subdomain" {
  zone_id = aws_route53_zone.seehmat_new.id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
}
