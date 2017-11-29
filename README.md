# `etcd3-terraform`

A Terraform recipe for a robust etcd cluster on AWS. This is based on the setup we use internally at Monzo (which you can read more about in our blog post), but is self-contained.

**⚠️ Warning**  
This is an illustration of how we run etcd clusters. This should not be deployed to production without first securing the infrastructure. For example, for ease, all instances have public IP addresses with SSH open to the internet in these manifests, and you probably don't want that for production workloads.

## Stack 🎮

This will create a new VPC and a set of 9 Auto Scaling Groups each running a single CoreOS image. These ASGs are distributed over 3 Availability Zones which you can specify by editing `variables.tf`, or creating a `terraform.tfvars` with overrides.

This will also create a Route 53 zone for the domain you pick and bind it to the VPC so its records can be resolved. This domain does not need to be registered. An `SRV` record suitable for etcd discovery is also created as well as a Lambda function which monitors ASG events and creates `A` records for each member of the cluster.

An Elastic Load Balancer will be created for clients of the etcd cluster. It fronts all 9 ASGs on port `2379`.

## How to use 🕹

The file `variables.tf` declares the Terraform variables required to run this stack. It contains some defaults AWS (Region, AZ, etc). You will be asked to provide an SSH public key to launch the stack. Variables can all be overridden in a `terraform.tfvars` file.

## AWS Limits 👮

New AWS accounts have default limits in place which may prevent you from launching this stack. Those we ran into are:

* **EC2 Instances**: There is a default limit of 5 instances. This will need to be raised to at least 9.
