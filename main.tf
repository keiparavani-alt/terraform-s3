module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket_name                     = var.bucket_name
  tags                            = var.tags
  enable_versioning               = var.enable_versioning
  encryption_type                 = var.encryption_type
  enable_lifecycle                = var.enable_lifecycle
  noncurrent_days                 = var.noncurrent_days
  enable_storage_transitions      = var.enable_storage_transitions
  transition_to_ia_days           = var.transition_to_ia_days
  transition_to_glacier_days      = var.transition_to_glacier_days
  transition_to_deep_archive_days = var.transition_to_deep_archive_days
}