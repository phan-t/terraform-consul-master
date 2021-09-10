provider "boundary" {
  addr             = var.url
  recovery_kms_hcl = <<EOT
kms "awskms" {
	purpose    = "recovery"
  region     = "ap-southeast-2"
	key_id     = "global_root"
  kms_key_id = "${var.kms_recovery_key_id}"
}
EOT
}

# global scope
resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
}

# org scope
resource "boundary_scope" "ep-apj" {
  name                     = "EP APJ"
  description              = "EP APJ Team" 
  scope_id                 = boundary_scope.global.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

# project scope
resource "boundary_scope" "tphan-test" {
  name                     = var.deployment_name
  scope_id                 = boundary_scope.ep-apj.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

# auth method
resource "boundary_auth_method" "password" {
  scope_id = boundary_scope.ep-apj.id
  type     = "password"
}

resource "boundary_account" "users_acct" {
  for_each       = var.users
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = "HashiCorp1!"
  auth_method_id = boundary_auth_method.password.id
}

resource "boundary_user" "users" {
  for_each    = var.users
  name        = each.key
  description = "User resource for ${each.key}"
  account_ids = [boundary_account.users_acct[each.value].id]
  scope_id    = boundary_scope.ep-apj.id
}

resource "boundary_role" "ep-apj-admin" {
  scope_id        = boundary_scope.ep-apj.id
  #scope_id        = boundary_scope.global.id
  #grant_scope_id  = boundary_scope.ep-apj.id
  grant_strings   = ["id=*;type=*;actions=*"]
  principal_ids   = concat([for user in boundary_user.users: user.id])
}

resource "boundary_role" "tphan-test-admin" {
  scope_id        = boundary_scope.tphan-test.id
  #scope_id        = boundary_scope.ep-apj.id
  #grant_scope_id  = boundary_scope.tphan-test.id
  grant_strings   = ["id=*;type=*;actions=*"]
  principal_ids   = concat([for user in boundary_user.users: user.id])
}

/*
resource "boundary_host_catalog" "infra" {
  name        = "Infrastructure"
  type        = "static"
  scope_id    = boundary_scope.tphan-test.id
}

resource "boundary_host" "cts-node" {
  type            = "static"
  name            = "cts-node"
  description     = "Consul-Terraform-Sync"
  address         = "10.200.21.216"
  host_catalog_id = boundary_host_catalog.infra.id
}

resource "boundary_host_set" "consul-infra" {
  type            = "static"
  name            = "consul_infra"
  description     = "Consul Infrastructure"
  host_catalog_id = boundary_host_catalog.infra.id
  host_ids        = [boundary_host.cts-node.id]
}

resource "boundary_target" "cts-node" {
  type                     = "tcp"
  name                     = "cts-node"
  description              = "Consul-Terraform-Sync"
  scope_id                 = boundary_scope.tphan-test.id
  session_connection_limit = -1
  default_port             = 22
  host_set_ids             = [boundary_host_set.consul-infra.id]
}
*/

resource "boundary_host_catalog" "infra" {
  name        = "Infrastructure"
  type        = "static"
  scope_id    = boundary_scope.tphan-test.id
}

resource "boundary_host" "consul-infra" {
  for_each        = var.consul_infra_ips
  type            = "static"
  name            = "consul_infra_service_${each.value}"
  address         = each.key
  host_catalog_id = boundary_host_catalog.infra.id
}

resource "boundary_host_set" "consul-infra-ssh" {
  type            = "static"
  name            = "consul_infra_ssh"
  host_catalog_id = boundary_host_catalog.infra.id
  host_ids        = [for host in boundary_host.consul-infra : host.id]
}

# create target for accessing servers on port :22
resource "boundary_target" "consul-infra-ssh" {
  type         = "tcp"
  name         = "ssh_server"
  scope_id     = boundary_scope.tphan-test.id
  default_port = "22"
  host_set_ids = [boundary_host_set.consul-infra-ssh.id]
}
