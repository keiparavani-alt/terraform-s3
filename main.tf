module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket_name                     = var.bucket_name
  tags                            = var.tags
  enable_versioning               = var.enable_versioning
  encryption_type                 = var.encryption_type
  enable_lifecycle                = var.enable_lifecycle
  noncurrent_days                 = var.noncurrent_days
  transition_to_ia_days           = var.transition_to_ia_days
  transition_to_glacier_days      = var.transition_to_glacier_days
  transition_to_deep_archive_days = var.transition_to_deep_archive_days

  enable_bucket_policy = true

  read_principals  = var.read_principals
  write_principals = var.write_principals
  delete_principals = var.delete_principals
  admin_principals = var.admin_principals

  enable_transition_to_ia            = var.enable_transition_to_ia
  enable_transition_to_glacier       = var.enable_transition_to_glacier
  enable_transition_to_deep_archive  = var.enable_transition_to_deep_archive
}