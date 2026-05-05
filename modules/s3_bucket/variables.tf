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

variable "transition_to_ia_days" {
  type = number
}

variable "transition_to_glacier_days" {
  type = number
}

variable "transition_to_deep_archive_days" {
  type = number
}

variable "enable_bucket_policy" {
  type    = bool
  default = true
}

variable "read_principals" {
  type    = list(string)
  default = []
}

variable "write_principals" {
  type    = list(string)
  default = []
}

variable "delete_principals" {
  type    = list(string)
  default = []
}

variable "admin_principals" {
  type    = list(string)
  default = []
}

variable "enable_transition_to_ia" {
  type    = bool
  default = true
}

variable "enable_transition_to_glacier" {
  type    = bool
  default = true
}

variable "enable_transition_to_deep_archive" {
  type    = bool
  default = true
}