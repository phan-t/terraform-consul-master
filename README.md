<h1>
  <img src="./assets/logo.svg" align="left" height="46px" alt="Consul logo"/>
  <span>Consul Demo-as-Code (DaC)</span>
</h1>

## Overview

## Architecture

## Usage

### HashiCups Multi-Cloud Module `hashicups-multi-cloud`


### Useful Commands
#### Create `kubeconfig` for Amazon EKS
```shell
aws eks --region $(terraform output -raw aws_region) update-kubeconfig --name $(terraform output -raw deployment_id)
```
#### Create `kubeconfig` for Google Cloud Platform GKE
```
gcloud container clusters get-credentials $(terraform output -raw deployment_id) --region $(terraform output -raw gcp_region)
```
#### Get Consul ACL Bootstrap Token
```
kubectl get --namespace consul secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -d)
```

### Prerequisites
This terraform module assumes you have an active HashiCorp Cloud Platform (HCP), Amazon Web Services (AWS) and Microsoft Azure subscriptions. For terraform to provision HCP resources, it requires the `hcp_client_id` and `hcp_client_secret`.

#### Example `terraform.tfvars`
```
deployment_name = ""
owner = ""
ttl = ""
enable_cts_aws = false
hcp_region = ""
hcp_client_id = ""
hcp_client_secret = ""
aws_region = ""
aws_key_pair_key_name = ""
gcp_region = ""
gcp_project_id = ""
consul_helm_chart_version = ""
consul_version = ""
consul_ent_license = ""
```