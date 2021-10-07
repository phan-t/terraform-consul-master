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
terraform destroy -target module.consul-aws-server.helm_release.consul
```