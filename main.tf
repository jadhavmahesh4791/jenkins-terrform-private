terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

### We need to run AWS Configure locally and put the access keys and secret key of 
### IAM user who is authorise to assume the below role.

provider "aws" {
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::851725402722:role/terraform-role" # Terraform role which will be assume to create resources
  }
}

