# sbucket.tf
# Website S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket        = "seehmat.com-website"
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

resource "aws_s3_bucket" "bucket2" {
  bucket = var.website_bucket_name
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Website Bucket Policy (Replaces ACL)
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  depends_on = [
    aws_s3_bucket_public_access_block.website_bucket_access_block
  ]
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}
# Logs S3 Bucket
resource "aws_s3_bucket" "logs_bucket" {
  bucket = var.logs_bucket_name
  
  bucket        = "seehmat.com-logs"
  force_destroy = true
  tags = {
    Name        = "CloudFront Logs Bucket"
    Environment = "production"
    Name        = "Logs Bucket"
    Environment = "Production"
  }
}

# Public Access Block for Logs Bucket
resource "aws_s3_bucket_public_access_block" "logs_bucket_access_block" {
  bucket = aws_s3_bucket.logs_bucket.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "default" {
  name                           = "S3OriginAccessControl"
  name                           = "SeehmatS3OriginAccessControl"
  origin_access_control_origin_type = "s3"
  signing_behavior               = "always"
  signing_protocol               = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.bucket2.bucket_regional_domain_name
    origin_access_control_id = var.origin_access_control_id
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id                = "myS3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "resumework"
  default_root_object = "index.html"

  aliases = [var.domain_name]
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    target_origin_id       = "myS3Origin"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "myS3Origin"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

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
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

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
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  price_class = "PriceClass_100"
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.seehmat_cert.arn
    ssl_support_method        = "sni-only"
    minimum_protocol_version  = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
@@ -103,16 +119,6 @@ resource "aws_cloudfront_distribution" "s3_distribution" {
  }

  tags = {
    Environment = "production"
  }
  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 10
  }
  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
    Environment = "Production"
  }
}