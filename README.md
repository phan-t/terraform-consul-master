# Consul Demo-as-Code

## How to use this module

### Post Deployment
#### Create `kubeconfig` for Amazon EKS
```shell
aws eks --region $(terraform output -raw aws_region) update-kubeconfig --name $(terraform output -raw deployment_id)
```

### Pre Destroy
#### Destroy Consul Server
```shell
terraform destroy -target module.consul-aws-server.helm_release.consul
```