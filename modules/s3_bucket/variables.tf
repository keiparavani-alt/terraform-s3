variable "bucket_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "enable_versioning" {
  type = bool
}

variable "encryption_type" {
  type = string
}

variable "enable_lifecycle" {
  type = bool
}

variable "noncurrent_days" {
  type = number
}

variable "enable_storage_transitions" {
  type = bool
}

variable "transition_to_ia_days" {
  type = number
}

variable "transition_to_glacier_days" {
  type = number
}

variable "transition_to_deep_archive_days" {
  type = number
}