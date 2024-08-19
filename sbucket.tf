# S3 Bucket for storing website content
# This block creates an S3 bucket named "seehmatbuck" where your website content will be stored.
resource "aws_s3_bucket" "bucket2" {
  bucket = "seehmatbuck"
}

# S3 Bucket for CloudFront logs
# This block creates an additional S3 bucket named "seehmatbuck-logs" specifically for storing CloudFront logs.
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "seehmatbuck-logs"
  
  tags = {
    Name        = "CloudFront Logs Bucket"
    Environment = "production"
  }
}

# CloudFront Origin Access Control for securing S3 access
# This block configures CloudFront to securely access the S3 bucket using SigV4 signing (AWS Signature Version 4).
resource "aws_cloudfront_origin_access_control" "default" {
  name                           = "S3OriginAccessControl"
  origin_access_control_origin_type = "s3"
  signing_behavior               = "always"
  signing_protocol               = "sigv4"
}

# Local variable for S3 Origin ID
# This local variable is used to reference the S3 origin ID in the CloudFront distribution configuration.
locals {
  s3_origin_id = "myS3Origin"
}

# CloudFront distribution configuration
# This block configures a CloudFront distribution to serve content from the S3 bucket to users with optimized performance and security.
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.bucket2.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "resumework"
  default_root_object = "index.html"

  # Aliases (custom domain names) for the CloudFront distribution
  aliases = ["seehmat.com"]

  # Default cache behavior configuration
  # This block defines how CloudFront will cache and deliver the content from the S3 bucket.
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Additional cache behavior for immutable content (e.g., assets that never change)
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior for other content
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Price class configuration for CloudFront distribution
  # This setting limits the distribution to specific regions to reduce cost.
  price_class = "PriceClass_100"

  # Geo restriction configuration
  # This block allows or restricts access to the content based on the viewer's geographic location.
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  # Custom error response configuration
  # This block handles custom error responses, such as returning a specific error page.
  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 10
  }

  # SSL/TLS certificate configuration
  # This block configures the SSL/TLS certificate for HTTPS traffic using Amazon's Certificate Manager (ACM).
  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.seehmat_cert.arn
    ssl_support_method  = "sni-only"
  }
}

