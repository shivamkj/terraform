resource "aws_lb" "load_balancer" {
  name               = "${var.app_name}-${var.environment}-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default_subnets.ids
  security_groups    = [aws_security_group.lb_security_group.id]
}

resource "aws_lb_target_group" "lb_ec2_instances" {
  name     = "${var.app_name}-${var.environment}-ec2-instances"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "target_group_instances" {
  for_each = local.instances


  target_group_arn = aws_lb_target_group.lb_ec2_instances.arn
  target_id        = aws_instance.ec2_instances[each.key].id
  port             = 3000
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "<h1>404: page not found</h1>"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "ec2_listener_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_ec2_instances.arn
  }
}
