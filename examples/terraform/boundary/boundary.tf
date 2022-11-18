data "terraform_remote_state" "tcm" {
  backend = "local"

  config = {
    path = "../../../terraform.tfstate"
  }
}

data "http" "auth-method" {
  url = "${data.terraform_remote_state.tcm.outputs.hcp_boundary_public_endpoint_url}/v1/auth-methods?scope_id=global"

  request_headers = {
    Accept = "application/json"
  }
}

resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
}

resource "boundary_scope" "orgs" {
  for_each = var.boundary_config

  name                     = each.key
  description              = each.value.description
  scope_id                 = boundary_scope.global.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "projects-avobank" {
  for_each = var.boundary_config["avobank"].projects

  name                     = each.value.name
  scope_id                 = boundary_scope.orgs["avobank"].id
  auto_create_admin_role   = true
}