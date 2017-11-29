provider "aws" {}

variable "instance_type" {
    default = "c4.large"
}

variable "region" {
    default = "eu-west-1"
}

variable "azs" {
    default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "environment" {
    default = "staging"
}

variable "role" {
    default = "etcd3-test"
}

variable "ami" {
    default = "ami-a0ff1ed9"
}

variable "vpc_cidr" {
    default = "10.200.0.0/16"
}

variable "dns" {
    type = "map"
    default = {
        domain_name = "example.com"
    }
}

variable "root_key_pair_public_key" {
}

variable "cluster_size" {
    default = 9
}

variable "ntp_host" {
    default = "0.europe.pool.ntp.org"
}
