# etcd3-terraform
A Terraform recipe for a robust etcd cluster on AWS. This is based on the setup we use internally at Monzo, but is self-contained.

## Stack
This will create a new VPC and a set of 9 Auto Scaling Groups each running a single CoreOS image. These ASGs are distributed over 3 Availability Zones which you can specify by editing `variables.tf`, or creating a `terraform.tfvars` with overrides.

This will also create a Route 53 zone for the domain you pick and bind it to the VPC so its records can be resolved. This domain does not need to be registered. An `SRV` record suitable for etcd discovery is also created as well as a Lambda function which monitors ASG events and creates `A` records for each member of the cluster.

An Elastic Load Balancer will be created for clients of the etcd cluster. It fronts all 9 ASGs on port `2379`.

## How to use
The file variables.tf declares the Terraform variables required to run this stack. It contains some random defaults for AWS Regions, AZs and root ssh keys which you will need to change to reflect your infrastructure. You can either change the defaults directly or overwrite them by providing a terraform.tfvars file.

