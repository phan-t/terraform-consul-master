# terraform-consul-master

### Retrieve the access credentials for your EKS cluster and automatically configure `kubectl`
```shell
aws eks --region $(terraform output -raw aws_region) update-kubeconfig --name $(terraform output -raw aws_eks_cluster_name)
```