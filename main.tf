data "template_file" "ec2_cloud_init" {
  template = "${file("${path.module}/scripts/cloud-init-custom-ec2.tpl")}"

  vars {
    deploymentID = "${var.deploymentID}"
  }
}

resource "aws_instance" "custom_ec2" {
    count = 1
    ami = "ami-0f2b4fc905b0bd1f1"  
    instance_type = "${var.EC2Size}"
    monitoring = "false"
    associate_public_ip_address = "true"
    subnet_id = "${element(var.subnet_ids, count.index)}"
    vpc_security_group_ids = ["${aws_security_group.neito_security_group.id}"]
    root_block_device = ["${var.ec2_root_block_device}"]
    user_data = "${data.template_file.ec2_cloud_init.rendered}"
}

resource "aws_security_group" "neito_security_group" {
  name = "neito_security_group"
  description = "Port needed for developpement"
  revoke_rules_on_delete = "true"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "80_ingress" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.neito_security_group.id}"
  description = "Enables HTTP."
}

resource "aws_security_group_rule" "22_ingress" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.neito_security_group.id}"
  description = "Enables SSH."
}
resource "aws_security_group_rule" "443_ingress" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.neito_security_group.id}"
  description = "Enables HTTPS"
}

resource "aws_security_group_rule" "9000_ingress" {
  type = "ingress"
  from_port = 9000
  to_port = 9000
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.neito_security_group.id}"
  description = "Enables Portainer"
}

resource "aws_security_group_rule" "9001_ingress" {
  type = "ingress"
  from_port = 9001
  to_port = 9001
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.neito_security_group.id}"
  description = "Enables Jenkins"
}