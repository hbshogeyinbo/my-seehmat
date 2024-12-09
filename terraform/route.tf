data "aws_route53_zone" "selected" {
  name = "seehmat.com"
# Automatically find or create an ACM certificate
resource "aws_acm_certificate" "seehmat_cert" {
  provider = aws.us
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_acm_certificate" "seehmat_cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
  provider    = aws.us
  key_types   = ["RSA_2048"]
# DNS Validation Records for ACM Certificate
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.seehmat_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
  zone_id = aws_route53_zone.seehmat_zone.id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 300
}

# Root Domain Record (A Record)
resource "aws_route53_record" "root_domain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  zone_id = aws_route53_zone.seehmat_zone.id
  name    = var.domain_name
  type    = "A"

@@ -22,8 +39,9 @@ resource "aws_route53_record" "root_domain" {
  }
}

# Subdomain Record (CNAME Record for www)
resource "aws_route53_record" "www_subdomain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  zone_id = aws_route53_zone.seehmat_zone.id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300