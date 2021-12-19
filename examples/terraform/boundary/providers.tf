terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "~>1.0.5"
    }
  }
}

provider "boundary" {
  addr             = data.terraform_remote_state.tcm.outputs.boundary_controller_public_address
  recovery_kms_hcl = <<EOT
kms "awskms" {
	purpose    = "recovery"
	key_id     = "global_root"
  region     = "${data.terraform_remote_state.tcm.outputs.aws_region}"
  kms_key_id = "${data.terraform_remote_state.tcm.outputs.boundary_kms_recovery_key_id}"
}
EOT
}