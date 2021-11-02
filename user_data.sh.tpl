#!/bin/bash

# Always update packages installed.
yum update -y

# Add the HashiCorp RPM repository.
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install a specific version of consul.
yum install -y consul-${consul_version}

# 169.254.169.254 is an Amazon service to provide information about itself.
my_hostname="$(curl http://169.254.169.254/latest/meta-data/hostname)"
my_ipaddress="$(curl http://169.254.169.254/latest/meta-data/local-ipv4)"

mv /etc/consul.d/consul.hcl /etc/consul.d/consul.hcl.orig
# Place the consul configuration.
cat << EOF > /etc/consul.d/consul.hcl

datacenter = "${consul_datacenter}"

data_dir = "/opt/consul"

client_addr = "$${my_ipaddress}"

ui_config {
  enabled = true
}

server = true

bind_addr = "$${my_ipaddress}"

encrypt = "${random_string}"

retry_join = ["provider=aws tag_key=name tag_value=${name}"]
EOF

# Start and enable consul.
systemctl --now enable consul
