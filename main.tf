resource "random_id" "bucket_id" {
  byte_length = 4
}
#creation of bucket (Unique name)
#tags to see costs, id what is what
resource "aws_s3_bucket" "my_bucket" {
  #if user provides a name use it
  #otherwise, random id
  bucket = var.bucket_name != "" ? var.bucket_name : "kei-${random_id.bucket_id.hex}"

  tags = {
    Name        = var.bucket_name != "" ? var.bucket_name : "kei-${random_id.bucket_id.hex}"
    Environment = var.environment
    Owner       = var.owner

  }

  lifecycle {
    prevent_destroy = true
  }
}
#versioning, useful for saving data, accidental deletes
resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
#encryption, using variable default is AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption_type
    }
  }
}
#public access block 
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
#lifecycle rule, needed because of versioning
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_days
    }
  }
}
