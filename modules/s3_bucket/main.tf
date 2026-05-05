locals {
  bucket_suffix     = formatdate("YYYYMMDD-hhmmss", timestamp())
  final_bucket_name = var.bucket_name != "" ? "${var.bucket_name}-${local.bucket_suffix}" : "kei-${local.bucket_suffix}"
}

#creation of bucket (Unique name)
#tags to see costs, id what is what
resource "aws_s3_bucket" "my_bucket" {
  #if user provides a name use it
  #otherwise, random id
  #now it doesnt use random id uses date adn time it was created
  bucket = local.final_bucket_name


  tags = merge(
    var.tags,
    {
    Name = local.final_bucket_name }
  )


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
#lifecycle rule, needed because of versioning, different age for different docs, default true
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    id     = "storage-transitions-and-cleanup"
    status = "Enabled"

    filter {
      prefix = ""
    }

    dynamic "transition" {
      for_each = var.enable_transition_to_ia ? [1] : []
      content {
        days          = var.transition_to_ia_days
        storage_class = "STANDARD_IA"
      }
    }

    dynamic "transition" {
      for_each = var.enable_transition_to_glacier ? [1] : []
      content {
        days          = var.transition_to_glacier_days
        storage_class = "GLACIER"
      }
    }

    dynamic "transition" {
      for_each = var.enable_transition_to_deep_archive ? [1] : []
      content {
        days          = var.transition_to_deep_archive_days
        storage_class = "DEEP_ARCHIVE"
      }
    }
  }
}
#variable for bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = var.enable_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json

  depends_on = [
    aws_s3_bucket_public_access_block.block_public
  ]
}

data "aws_iam_policy_document" "bucket_policy" {

  # READ
  dynamic "statement" {
    for_each = length(var.read_principals) > 0 ? [1] : []

    content {
      sid    = "ReadAccess"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.read_principals
      }

      actions = [
        "s3:ListBucket"
      ]

      resources = [
        aws_s3_bucket.my_bucket.arn
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.read_principals) > 0 ? [1] : []

    content {
      sid    = "ReadObjects"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.read_principals
      }

      actions = [
        "s3:GetObject"
      ]

      resources = [
        "${aws_s3_bucket.my_bucket.arn}/*"
      ]
    }
  }

  # WRITE
  dynamic "statement" {
    for_each = length(var.write_principals) > 0 ? [1] : []

    content {
      sid    = "WriteAccess"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.write_principals
      }

      actions = [
        "s3:PutObject"
      ]

      resources = [
        "${aws_s3_bucket.my_bucket.arn}/*"
      ]
    }
  }

  # DELETE
  dynamic "statement" {
    for_each = length(var.delete_principals) > 0 ? [1] : []

    content {
      sid    = "DeleteAccess"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.delete_principals
      }

      actions = [
        "s3:DeleteObject"
      ]

      resources = [
        "${aws_s3_bucket.my_bucket.arn}/*"
      ]
    }
  }

  # ADMIN
  dynamic "statement" {
    for_each = length(var.admin_principals) > 0 ? [1] : []

    content {
      sid    = "AdminAccess"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.admin_principals
      }

      actions = [
        "s3:*"
      ]

      resources = [
        aws_s3_bucket.my_bucket.arn,
        "${aws_s3_bucket.my_bucket.arn}/*"
      ]
    }
  }
}