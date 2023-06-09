output "application_lb_addr" {
  value = aws_lb.load_balancer.dns_name
}

output "cert_dns_validation" {
  value = aws_acm_certificate.cert.domain_validation_options
}
