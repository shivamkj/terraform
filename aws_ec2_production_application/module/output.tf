output "application_lb_addr" {
  value = aws_lb.load_balancer.dns_name
}
