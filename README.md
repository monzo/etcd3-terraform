# etcd3-terraform
A Terraform recipe for a robust etcd cluster on AWS. This is based on the setup we use internally at Monzo, except it is self-cointained.

## Stack
This will create a new VPC and a set of 9 ASGs each running a single node. These ASGs are distributed over 3 AZs which you can specify by editing variables.tf or creating a terraform.tfvars with overrides.

This will also create a Route 53 zone for the domain you pick and bind it to the VPC so its records can be resolved from it. This domain does not need to be registered. An SRV record suitable for etcd discovery is also created as well as a lambda function which monitors ASG events and creates A records for each member of the cluster.

An ELB will be created for clients of the etcd cluster. It fronts all 9 ASGs on port 2379.

## Contributions
Please let us know if you encounter any issues.

