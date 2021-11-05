output "aws_lb_dns_name" {
  description = "The DNS name of the loadbalancer."
  value       = aws_lb.default.dns_name
}

output "bastion_host_public_ip" {
  description = "The IP address of the bastion host."
  value       = try(aws_instance.bastion[0].public_ip, "No bastion host created.")
}

output "consul_instances" {
  description = "The private addresses of the Consul hosts. You can reach these throught the bastion host."
  value       = flatten(data.aws_instances.default[*].private_ips)
}
