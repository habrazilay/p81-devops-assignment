provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.bucket_prefix

  tags = {
    Name      = "ProductCloudFront"
    Owner     = var.tags.owner
    Terraform = var.tags.terraform
  }
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
  comment = "OAI for accessing S3 bucket through CloudFront"
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          CanonicalUser = aws_cloudfront_origin_access_identity.frontend_oai.s3_canonical_user_id
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name              = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Daniel's CloudFront Distribution"
  default_root_object = "filtered_products.json"

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

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist" 
      locations        = ["US", "IL"]
    }
  }

  tags = {
    Environment = var.tags.environment
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

## S3 Bucket for Terraform State ##

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_prefix + "-terraform-state"

  tags = {
    Name = "TerraformState"
    Environment = var.tags.environment
  }
}

## DynamoDB Table for State Locking ##
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TerraformLocks"
    Environment = var.tags.environment
  }
}

