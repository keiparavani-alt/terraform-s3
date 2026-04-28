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
