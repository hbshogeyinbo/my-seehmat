
# resource "aws_s3_bucket" "bucket1" {
#   bucket = "ungkbuck"

#   tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }
# }



# provider "aws" {
#   region = "eu-west-1"
# }

# S3 Bucket for storing website content
# cloudfront.tf

# S3 Bucket for storing website content
resource "aws_s3_bucket" "bucket2" {
  bucket = "seehmatbuck"
}

# Uploading website content to S3 bucket
resource "aws_s3_object" "object1" {
  bucket       = aws_s3_bucket.bucket2.bucket
  key          = "index.html"
  source       = "C:/Users/hamee/Desktop/example html/index.html"
  content_type = "text/html"  # Correct MIME type
}

resource "aws_s3_object" "object2" {
  bucket       = aws_s3_bucket.bucket2.bucket
  key          = "styles.css"
  source       = "C:/Users/hamee/Desktop/example html/styles.css"
  content_type = "text/css"  # Correct MIME type
}

resource "aws_s3_object" "object3" {
  bucket       = aws_s3_bucket.bucket2.bucket
  key          = "scripts.js"
  source       = "C:/Users/hamee/Desktop/example html/scripts.js"
  content_type = "application/javascript"  # Correct MIME type
}

resource "aws_s3_object" "object4" {
  bucket = aws_s3_bucket.bucket2.bucket
  key    = "pexels-thanhhoa-tran-640546-1462892.jpg"
  source = "C:/Users/hamee/Desktop/example html/pexels-thanhhoa-tran-640546-1462892.jpg"
}

resource "aws_s3_object" "object5" {
  bucket = aws_s3_bucket.bucket2.bucket
  key    = "1716252776052.jpg"
  source = "C:/Users/hamee/Desktop/example html/1716252776052.jpg"
}

# S3 Bucket for CloudFront logs
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "seehmatbuck-logs"
  
  tags = {
    Name        = "CloudFront Logs Bucket"
    Environment = "production"
  }
}

# CloudFront Origin Access Control for securing S3 access
resource "aws_cloudfront_origin_access_control" "default" {
  name                           = "S3OriginAccessControl"
  origin_access_control_origin_type = "s3"
  signing_behavior               = "always"
  signing_protocol                = "sigv4"
}

locals {
  s3_origin_id = "myS3Origin"
}

# CloudFront distribution configuration
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

  aliases = ["seehmat.com"]

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

  # Cache behavior with precedence 0
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

  # Cache behavior with precedence 1
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

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  # Custom error response configuration without a custom page
custom_error_response {
  error_code            = 403
  error_caching_min_ttl = 10
}


  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.seehmat_cert.arn
    ssl_support_method  = "sni-only"
  }
}




# Placeholders Explanation:
# 1. Bucket name (was "mybucket") is now "seehmatbuck".
# 2. Tag value (if any) for the bucket can be changed.
# 3. Origin ID in locals (optional) if a different one is needed.
# 4. Logging bucket name and prefix in the logging_config block.
# 5. Aliases for the CloudFront distribution should reflect your actual domain names.
# 6. Geo-restrictions if you want to modify allowed countries.
# 7. Tag value for the CloudFront distribution.
# 8. The ACM certificate ARN reference is linked to your domain certificate for SSL/TLS.

