#Variable folder so everything can be used in the future

#region vaiable
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

#tag for the enviroment (optional)
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
#tag for the owner (optional)
variable "owner" {
  description = "Owner of the resource"
  type        = string
  default     = "Kei"
}
#variable for the lifecycle(default is its turned on)
variable "enable_lifecycle" {
  description = "Enable lifecycle rule for old object versions"
  type        = bool
  default     = true
}
#variable for the days of the lifecycle
variable "noncurrent_days" {
  description = "Days before old object versions are deleted"
  type        = number
  default     = 30
}

#optional custom bucket name
#leave empty ("") to use auto-generated name
variable "bucket_name" {
  description = "Custom S3 bucket name (optional). If empty, a random name will be used."
  type        = string
  default     = ""
}

#variable for making versioning optional 
variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}


#decides encryption type, default is AES256
variable "encryption_type" {
  description = "S3 encryption type. Use AES256 for SSE-S3 or aws:kms for SSE-KMS."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.encryption_type)
    error_message = "encryption_type must be either AES256 or aws:kms."
  }
}