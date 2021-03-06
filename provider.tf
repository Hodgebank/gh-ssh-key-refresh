terraform {
  required_version = ">= 0.12.0"
  backend "s3" {}
}

provider "aws" {
  version = ">= 2.70.0"
  region  = local.aws_region
}

provider "github" {
  base_url   = local.gh_base_url
  token      = local.gh_pat
}