#providers for terraform, aws because aws, random for random bucket name 
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
#default region of sandbox
provider "aws" {
  region = var.region
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
#creation of bucket (Unique name)
#tags to see costs, id what is what
resource "aws_s3_bucket" "my_bucket" {
  bucket = "kei-${random_id.bucket_id.hex}"
  tags = {
    Name        = "kei-${random_id.bucket_id.hex}"
    Environment = var.environment
    Owner       = var.owner
}
}
#versioning, useful for saving data, accidental deletes
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
#encryption, Use AWS-managed encryption (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
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
#prevents terraform destroy from deleting bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "kei-${random_id.bucket_id.hex}"
  lifecycle {
    prevent_destroy = true
  }
}