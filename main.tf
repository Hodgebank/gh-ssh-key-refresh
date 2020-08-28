locals {
  gh_user               = var.gh_user
  ssm_param_name_gh_pat = "/global/gh-${local.gh_user}-pat"
  ssm_param_name_gh_rsa = "/global/gh-${local.gh_user}-rsa"
  environment           = var.environment
  gh_base_url           = var.gh_base_url
  aws_region            = var.aws_region
}

# short-lived keypair
resource "tls_private_key" "private_key" {

  triggers = {
    build_number = "${timestamp()}"
  }

  algorithm = "RSA"
  rsa_bits  = 4096
}

# short-lived private key
resource "aws_ssm_parameter" "private_key" {
  name      = local.ssm_param_name_gh_rsa
  type      = "SecureString"
  value     = tls_private_key.private_key.private_key_pem
  overwrite = true

}

# short-lived public key
resource "github_user_ssh_key" "pub_key" {
  title = "gh-${local.gh_user}-${local.environment}-rsa"
  key   = tls_private_key.private_key.public_key_openssh
}