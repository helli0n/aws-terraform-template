provider "aws" {
  region     = var.AWS_REGION
  profile    = "my-aws"

}

terraform {
  required_version = ">= 1.0.5"
  backend "s3" {
    encrypt = true
    bucket = "s3-my-aws-terraform"
    key    = "my-aws-infra-state"
    region = "us-west-2"
    dynamodb_table = "terraform-lock"
    profile = "my-aws"
  }
}