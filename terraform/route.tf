data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  zone_id = data.aws_route53_zone.selected.id
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  ttl     = 300
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]

  depends_on = [aws_acm_certificate.cert]
}