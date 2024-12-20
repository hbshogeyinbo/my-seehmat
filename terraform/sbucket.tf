# Website S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket        = "seehmat.com"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Website Bucket"
    Environment = "Production"
  }
}

# Public Access Block for Website Bucket
resource "aws_s3_bucket_public_access_block" "website_bucket_access_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Website Bucket Policy for CloudFront
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  depends_on = [
    aws_s3_bucket_public_access_block.website_bucket_access_block
  ]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

# Logs S3 Bucket
resource "aws_s3_bucket" "logs_bucket" {
  bucket        = "seehmat.com-logs"
  force_destroy = true

  tags = {
    Name        = "Logs Bucket"
    Environment = "Production"
  }
}

# Public Access Block for Logs Bucket
resource "aws_s3_bucket_public_access_block" "logs_bucket_access_block" {
  bucket = aws_s3_bucket.logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "default" {
  name                            = "SeehmatS3OriginAccessControl"
  origin_access_control_origin_type = "s3"
  signing_behavior                = "always"
  signing_protocol                = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id                = "myS3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "myS3Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Add Alternate Domain Names (CNAMEs)
  aliases = [
    "seehmat.com",
    "www.seehmat.com"
  ]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.seehmat_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "Production"
  }
}

# Outputs
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}
