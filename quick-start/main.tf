terraform {
  required_providers {
    aws    = "~>3"
    random = "~>2"
  }
  required_version = ">= 0.15"
}

provider "aws" {

}

module "byoc" {
  source = "../."
}