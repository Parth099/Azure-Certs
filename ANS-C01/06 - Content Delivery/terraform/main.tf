locals {
  mime_types = {
    "html" = "text/html"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "png"  = "image/png"
    "css"  = "text/css"
    "js"   = "application/javascript"
  }
}

// -- create s3 static website hosting bucket

resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "all_access_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontSPN"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.bucket_public_access]
}

// Upload all files under ./html to the S3 bucket
resource "aws_s3_object" "html_files" {
  for_each = fileset("${path.module}/html", "*")
  bucket   = aws_s3_bucket.bucket.id
  key      = each.value

  source       = "${path.module}/html/${each.value}"
  content_type = lookup(local.mime_types, regex("\\.(\\w+)$", each.value)[0], "application/octet-stream")
}

// CloudFront distribution

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac-for-s3-staticweb-origin"
  description                       = "Origin Access Control for S3 static website hosting"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {

  origin {
    domain_name              = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  aliases = [
    "${var.cloudfront_ssl_info.cname}.${var.r53_domain_info.domain}"
  ]

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "CDN for static website hosted on S3"
  default_root_object = "index.html"

  ordered_cache_behavior {
    path_pattern           = "*.html"
    target_origin_id       = aws_s3_bucket.bucket.id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    min_ttl     = 0
    default_ttl = 0 # Don't cache HTML by default
    max_ttl     = 0 # Never cache HTML
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.bucket.id
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # open to all countries, but can be restricted using geo restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = [] # Add country codes to restrict access from specific countries
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = var.cloudfront_ssl_info.acm_certificate_arn
    ssl_support_method             = "sni-only"
  }

  price_class = "PriceClass_100"
}

// -- Optional: Route 53 record for custom domain
resource "aws_route53_record" "cdn_record" {
  zone_id = var.r53_domain_info.zoneID
  name    = var.cloudfront_ssl_info.cname
  type    = "CNAME"
  ttl     = 3600
  records = [aws_cloudfront_distribution.cdn.domain_name]
}


output "s3_access_url" {
  value = "http://${aws_s3_bucket_website_configuration.static_website_config.website_endpoint}"
}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

output "alternate_cloudfront_name" {
  value = "https://${var.cloudfront_ssl_info.cname}.${var.r53_domain_info.domain}"
}
