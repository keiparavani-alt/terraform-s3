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