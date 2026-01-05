terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket      = "tmdb-terraform-state"
    key         = "tmdb/terraform.tfstate"
    region      = "us-west-2"
    use_lockfile = true    # Enables S3 native locking
  }
}

provider "aws" {
  region = var.aws_region
}