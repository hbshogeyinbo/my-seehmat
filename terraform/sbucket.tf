resource "aws_s3_bucket" "app_bucket" {
  bucket        = "my-app-bucket-${var.environment}"
  acl           = "private"
  force_destroy = true

  tags = {
    Environment = var.environment
    Name        = "app-bucket-${var.environment}"
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket.app_bucket.bucket_regional_domain_name
    origin_id   = "s3-origin-${aws_s3_bucket.app_bucket.id}"
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin-${aws_s3_bucket.app_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
