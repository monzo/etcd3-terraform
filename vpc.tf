resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "etcd3-test"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "default"
  }
}

resource "aws_subnet" "default" {
  count             = "${length(var.azs)}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 2, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags {
    Name = "default"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.default.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "default"
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.default.default_network_acl_id}"
  subnet_ids             = ["${aws_subnet.default.*.id}"]

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "default"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
