### Default VPC & Subnets ID
data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

### EC2 Instances Security Group
resource "aws_security_group" "ec2_security_group" {
  name = "${var.app_name}-${var.environment}-ec2"
}

### Allow all HTTP traffic from Elastic Load Balancer
resource "aws_security_group_rule" "elb_ingress" {
  security_group_id        = aws_security_group.ec2_security_group.id
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_security_group.id
}

### Elastic Load Balancer Security Group
resource "aws_security_group" "lb_security_group" {
  name = "${var.app_name}-${var.environment}-lb"
}

### Allow all Inbound HTTP traffic
resource "aws_security_group_rule" "allow_lb_http_inbound" {
  security_group_id = aws_security_group.lb_security_group.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

### Allow all Inbound HTTPS traffic
resource "aws_security_group_rule" "allow_lb_https_inbound" {
  security_group_id = aws_security_group.lb_security_group.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

### Allow all Outbound traffic
resource "aws_security_group_rule" "allow_elb_all_outbound" {
  security_group_id = aws_security_group.lb_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
