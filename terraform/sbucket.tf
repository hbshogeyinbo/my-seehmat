resource "aws_s3_bucket" "app_bucket" {
  bucket        = "my-app-bucket-${var.environment}-${random_id.bucket_suffix.hex}"
  acl           = "private"                      # Secure bucket configuration
  force_destroy = true                           # Allow Terraform to delete bucket and contents

  tags = {
    Environment = var.environment
    Name        = "app-bucket-${var.environment}"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 8                                # Generate a unique suffix for the bucket name
}

resource "aws_s3_bucket_policy" "cloudfront_policy" {
  bucket = aws_s3_bucket.app_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_control.oac.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.app_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name          = "oac-${var.environment}"
  description   = "Origin access for CloudFront to S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                   = "always"
  signing_protocol                   = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket.app_bucket.bucket_regional_domain_name
    origin_id   = "s3-origin-${aws_s3_bucket.app_bucket.id}"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
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

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.geo_restrictions # Define list of allowed locations in var.tf
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}
