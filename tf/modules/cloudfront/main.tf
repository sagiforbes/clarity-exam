resource "aws_cloudfront_origin_access_control" "oac" {
  name          = "clarity-oac"
  description   = "OAC for clarity.sagiforbes S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                   = "always"
  signing_protocol                   = "sigv4"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled = true
  origin {
    domain_name = "${var.bucket_name}.s3.amazonaws.com"
    origin_id   = "clarity-s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "clarity-s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = var.tags
}

