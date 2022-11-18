terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "~>1.1.2"
    }
  }
}

provider "boundary" {
  addr                            = data.terraform_remote_state.tcm.outputs.hcp_boundary_public_endpoint_url
  auth_method_id                  = jsondecode(data.http.auth-method.response_body).items[0].id
  password_auth_method_login_name = var.init_user
  password_auth_method_password   = var.init_pass
}