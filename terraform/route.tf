data "aws_route53_zone" "selected" {
  name         = var.domain_name                  # Domain name for the Route 53 hosted zone
  private_zone = false
}

resource "aws_route53_key_signing_key" "dnssec_key" {
  hosted_zone_id = data.aws_route53_zone.selected.id
  name           = "dnssec-key-${var.environment}"
  status         = "ACTIVE"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_dnssec" "dnssec" {
  hosted_zone_id = data.aws_route53_zone.selected.id
}

resource "aws_route53_record" "cert_validation" {
  zone_id = data.aws_route53_zone.selected.id
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  ttl     = 300
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]

  depends_on = [aws_acm_certificate.cert]         # Ensure certificate is created first
}
