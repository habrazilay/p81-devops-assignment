# Creates an S3 bucket resource named "frontend_bucket" with a dynamic bucket name using a prefix.
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.bucket_prefix

  # Adds tags to the S3 bucket to help identify and manage resources.
  tags = {
    Name      = "ProductCloudFront"  
    Owner     = var.tags.owner       
    Terraform = var.tags.terraform   
  }
}

# Defines a local variable to hold the S3 origin ID for use in CloudFront.
locals {
  s3_origin_id = "myS3Origin"  # Local variable 's3_origin_id' is set to 'myS3Origin'.
}

# Creates a CloudFront Origin Access Identity (OAI) to securely access the S3 bucket. I could use OAC but it's more complex.
resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
  comment = "OAI for accessing S3 bucket through CloudFront"  
}

# Creates a bucket policy that allows CloudFront to access the S3 bucket using the OAI.
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id  # Associates the policy with the 'frontend_bucket' S3 bucket.

  # Defines the policy that allows CloudFront to access the S3 bucket. "Acces to the bucket should be allowed only from cloud front"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          CanonicalUser = aws_cloudfront_origin_access_identity.frontend_oai.s3_canonical_user_id  # Grants access to the CloudFront OAI.
        }
        Action   = "s3:GetObject"  # Allows the 's3:GetObject' action on the bucket.
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"  # Applies the policy to all objects in the bucket.
      }
    ]
  })
}

# Creates a CloudFront distribution that uses the S3 bucket as its origin.
resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name              = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name  # Sets the origin domain name to the S3 bucket's regional domain name.
    origin_id                = local.s3_origin_id  # Sets the origin ID using the local variable.
    
    # Configures the S3 origin to use the OAI for access.
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path  # Specifies the OAI for the S3 origin.
    }
  }

  enabled             = true  # Enables the CloudFront distribution.
  is_ipv6_enabled     = true  # Enables IPv6 for the distribution.
  comment             = "Daniel's CloudFront Distribution"  # Adds a comment describing the distribution.
  default_root_object = "filtered_products.json"  # Sets the default root object for the distribution.

  # Configures the default cache behavior for the CloudFront distribution.
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]  # Specifies allowed HTTP methods.
    cached_methods   = ["GET", "HEAD"]  # Specifies the methods that will be cached.
    target_origin_id = local.s3_origin_id  # Sets the target origin ID using the local variable.

    # Configures how CloudFront forwards values to the origin.
    forwarded_values {
      query_string = false  # Disables forwarding of query strings to the origin.

      # Configures how cookies are forwarded to the origin.
      cookies {
        forward = "none"  # Disables cookie forwarding.
      }
    }

    viewer_protocol_policy = "allow-all"  # Allows both HTTP and HTTPS requests.
    min_ttl                = 0  # Sets the minimum TTL for cached objects to 0 seconds.
    default_ttl            = 3600  # Sets the default TTL for cached objects to 1 hour.
    max_ttl                = 86400  # Sets the maximum TTL for cached objects to 1 day.
  }

  price_class = "PriceClass_200"  # Restricts the distribution to use the least expensive edge locations.

  # Configures geo-restriction to only allow access from specific countries.
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"  # Restricts access to a whitelist of countries.
      locations        = ["US", "IL"]  # Specifies the countries in the whitelist.
    }
  }

  # Adds tags to the CloudFront distribution for identification and management.
  tags = {
    Environment = var.tags.environment  # Tag 'Environment' is set to the value of 'environment' in the 'tags' variable.
  }

  # Configures the distribution to use the default CloudFront SSL certificate.
  viewer_certificate {
    cloudfront_default_certificate = true  # Enables the default CloudFront SSL certificate.
  }
}

# Creates an S3 bucket to store Terraform state files.
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_prefix}-terraform-state"  # Sets the bucket name using a prefix and suffix.
  tags = {
    Name = "TerraformState"  # Tags the bucket as 'TerraformState'.
    Environment = var.tags.environment  # Tag 'Environment' is set to the value of 'environment' in the 'tags' variable.
  }
}

# Creates a DynamoDB table to be used for Terraform state locking, preventing concurrent modifications.
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"  # Names the DynamoDB table 'terraform-locks'.
  billing_mode = "PAY_PER_REQUEST"  # Sets the billing mode to 'PAY_PER_REQUEST' for on-demand usage.
  hash_key     = "LockID"  # Defines 'LockID' as the primary key for the table.

  # Defines the attributes of the DynamoDB table.
  attribute {
    name = "LockID"  # Attribute name is 'LockID'.
    type = "S"  # Attribute type is string ('S').
  }

  # Adds tags to the DynamoDB table for identification and management.
  tags = {
    Name = "TerraformLocks"  # Tags the table as 'TerraformLocks'.
    Environment = var.tags.environment  # Tag 'Environment' is set to the value of 'environment' in the 'tags' variable.
  }
}
