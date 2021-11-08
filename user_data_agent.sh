#!/bin/bash

# Always update packages installed.
yum update -y

# Add the HashiCorp RPM repository.
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install a specific version of consul.
yum install -y consul-1.10.3

# 169.254.169.254 is an Amazon service to provide information about itself.
my_hostname="$(curl http://169.254.169.254/latest/meta-data/hostname)"
my_ipaddress="$(curl http://169.254.169.254/latest/meta-data/local-ipv4)"

mv /etc/consul.d/consul.hcl /etc/consul.d/consul.hcl.orig
# Place the consul configuration.
cat << EOF > /etc/consul.d/consul.hcl

datacenter = "dc1"

data_dir = "/opt/consul"

client_addr = "${my_ipaddress}"

ui_config {
  enabled = true
}

bind_addr = "${my_ipaddress}"

encrypt = "YlFdNy1XTEw0dUBZMipXUSlPSlBLZCM3ZTk/TilzLWg="

retry_join = ["provider=aws tag_key=name tag_value=consul-ajoewz"]
EOF

# Start and enable consul.
systemctl --now enable consul

# Allow users to use `consul`.
echo "export CONSUL_HTTP_ADDR=http://${my_ipaddress}:8500" >> /etc/profile
