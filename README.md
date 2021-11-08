# Consul Demo-as-Code

## How to use this module

### Post Deployment
#### Create `kubeconfig` for Amazon EKS
```shell
aws eks --region $(terraform output -raw aws_region) update-kubeconfig --name $(terraform output -raw deployment_id)
```

#### Login to Boundary
##### Set BOUNDARY_ADDR environmental variable
```shell
export BOUNDARY_ADDR=$(terraform output -raw boundary_controller_public_address)
```
##### Authenticate to Boundary
```shell
boundary authenticate password \
         -login-name=admin \
         -password password \
         -auth-method-id=ampw_1234567890
```

### Pre Destroy
#### Destroy Consul Server
```shell
terraform destroy -target module.consul-server-aws.helm_release.consul-server
```

### F5 BIG-IP Deployment
#### Prerequisites
* hashicorp/template v2.2.0

This provider has been archived, workaround for darwin_arm64:

1. Clone repo: https://github.com/hashicorp/terraform-provider-template
2. Build from source (eg. `go build`).
3. Move the resulting binary to the global terraform plugins path: `mv <resulting-binary-path> ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64/terraform-provider-template_v2.2.0_x5`
4. Assign exec permissions (eg. `chmod +x <binary-path-above>`)