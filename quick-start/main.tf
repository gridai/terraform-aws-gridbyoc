terraform {
  required_providers {
    aws    = "~>3"
    random = "~>3"
  }
  required_version = ">= 0.15"
}

provider "aws" {
  region = var.region
}

module "byoc" {
  source = "../."

  role_name = var.role_name
  grid_account_id = "748115360335"
}
