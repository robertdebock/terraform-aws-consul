output "aws_lb_dns_name" {
  description = "The DNS name of the loadbalancer."
  value       = aws_lb.default.dns_name
}

output "bastion_host_public_ip" {
  description = "The IP address of the bastion host."
  value       = aws_instance.bastion.public_ip
}

output "consul_instances" {
  description = "The private addresses of the Consul hosts. You can reach these throught the bastion host."
  value       = data.aws_instances.default[*].private_ips
}
