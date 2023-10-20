# Create s3 bucket
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags = {
    Name = "My bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [ aws_s3_bucket_ownership_controls.this ]
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}
# Create CloudFront origin access control
resource "aws_cloudfront_origin_access_control" "demo_origin_access_control" {
  name                            = "${aws_s3_bucket.this.id}.s3.us-west-1.amazonaws.com"
  origin_access_control_origin_type = "s3"
  signing_behavior                = "no-override"
  signing_protocol                = "sigv4"
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "demo_distribution" {
  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.demo_origin_access_control.id
    origin_id                = "${aws_s3_bucket.this.id}.s3.us-west-1.amazonaws.com"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"
# default cache behavior
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.this.id}.s3.us-west-1.amazonaws.com"

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
    compress = true
  }

 
  price_class = "PriceClass_200"

    restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.environment
  }

  viewer_certificate {
#    cloudfront_default_certificate = true
   ssl_support_method = "sni-only" 
   acm_certificate_arn = var.cert_arn
  }
aliases = ["${var.alt_domain}"]

  #Custom error response for single page applications
  custom_error_response {
    error_code      = 403
    response_code   = 200
    response_page_path = "/index.html"
  }
  custom_error_response {
    error_code      = 404
    response_code   = 200
    response_page_path = "/index.html"
  }
}

# Grant read permission to the CloudFront origin access identity
resource "aws_s3_bucket_policy" "demo_website_bucket_policy" {
  bucket = aws_s3_bucket.this.id

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.this.id}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::049526001344:distribution/${aws_cloudfront_distribution.demo_distribution.id}"
                }
            }
        }
    ]
}
EOF
}
