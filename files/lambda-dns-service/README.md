# `lambda-dns`

An AWS Lambda function to maintain Route 53 DNS records from EC2 events, using
the `role` tag on instances. Each instance is visible in two records:

* `${role}.${instance-az}.${environment-domain-name}`
* `${role}.${instance-region}.${environment-domain-name}`

So, for instance, these might be:

* `k8s-worker.eu-west-1a.i.prod.prod-ffs.io`
* `k8s-worker.eu-west-1.i.prod.prod-ffs.io`

Records have a deliberately short (5-second) TTL.
