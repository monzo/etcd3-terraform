resource "aws_launch_configuration" "default" {
  count                       = "${var.cluster_size}"
  name_prefix                 = "peer-${count.index}.${var.role}.${var.region}.i.${var.environment}.${var.dns["domain_name"]}-"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  ebs_optimized               = true
  iam_instance_profile        = "${aws_iam_instance_profile.default.id}"
  key_name                    = "${aws_key_pair.default.key_name}"
  enable_monitoring           = false
  associate_public_ip_address = true
  user_data                   = "${element(data.template_file.cloud-init.*.rendered, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "default" {
  count                     = "${var.cluster_size}"
  availability_zones        = ["${element(var.azs, count.index)}"]
  name                      = "peer-${count.index}.${var.role}.${var.region}.i.${var.environment}.${var.dns["domain_name"]}"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = "${element(aws_launch_configuration.default.*.name, count.index)}"
  vpc_zone_identifier       = ["${element(aws_subnet.default.*.id, count.index)}"]
  load_balancers            = ["${aws_elb.internal.name}"]

  tag {
    key                 = "Name"
    value               = "peer-${count.index}.${var.role}.${var.region}.i.${var.environment}.${var.dns["domain_name"]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "role"
    value               = "peer-${count.index}.${var.role}"
    propagate_at_launch = true
  }

  tag {
    key                 = "r53-domain-name"
    value               = "${var.environment}.${var.dns["domain_name"]}"
    propagate_at_launch = false
  }

  tag {
    key                 = "r53-zone-id"
    value               = "${aws_route53_zone.default.id}"
    propagate_at_launch = false
  }
}

resource "aws_ebs_volume" "ssd" {
  count               = "${var.cluster_size}"
  type                = "gp2"
  availability_zone   = "${element(var.azs, count.index)}"
  size                = 100

  tags {
    "Name"            = "peer-${count.index}-ssd.${var.role}.${var.region}.i.${var.environment}.${var.dns["domain_name"]}"
    "environment"     = "${var.environment}"
    "role"            = "peer-${count.index}-ssd.${var.role}"
  }
}
