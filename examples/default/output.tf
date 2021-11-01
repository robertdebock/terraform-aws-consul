output "consul_url" {
  description = "The URL to this consul installation."
  value       = "http://${module.consul.aws_lb_dns_name}:8500/ui/"
}

output "bastion_host_ip" {
  description = "The IP address of the bastion host."
  value       = module.consul.bastion_host_public_ip
}

output "consul_instances" {
  description = "The private addresses of the Consul hosts. You can reach these throught the bastion host."
  value       = module.consul.consul_instances
}
