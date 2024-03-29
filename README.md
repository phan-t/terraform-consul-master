# Consul Demo-as-Code

## How to use this module

### Post deployment
#### Create `kubeconfig` for Amazon EKS
```shell
aws eks --region $(terraform output -raw aws_region) update-kubeconfig --name $(terraform output -raw deployment_id)
```
#### Create `kubeconfig` for Google Cloud GKE
```
gcloud container clusters get-credentials $(terraform output -raw deployment_id) --region $(terraform output -raw gcp_region)
```

#### Get Consul ACL Bootstrap Token
```
kubectl get --namespace consul secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -d)
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

### Pre destroy
#### Destroy Consul Server
```shell
terraform destroy -target module.consul-server-aws.helm_release.consul-server
```