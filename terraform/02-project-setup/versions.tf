terraform {
  # https://www.terraform.io/docs/configuration/terraform.html
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.27.0"
    }
  }
  required_version = ">= 1.0.3"
}
