# HashiCorp Consul on AWS

This code spins up an opensource HashiCorp Consul cluster:

- Spread over availability zones.
- Automatically finding other nodes.
- With a load balancer.
- A bastion host.

## Overview

```text
                 +--- lb --------+
       +-------> | type: network |
       |         +---------------+
       |
       |         +--- lb_target_group ---+
       |   +---> | port: 8200            |  <-----------------------+
       |   |     +-----------------------+                          |
       |   |                                                        |
       |   |    +--- listener ---+   +--- autoscaling_group ---+    |
       +---+--- | port: 8200     |   |                         | ---+
                +----------------+   +-------------------------+
                                                   |
                                                   V      
                                     +--- launch_configuration ---+
                                     |                            |
                                     +----------------------------+
```

These variables can be used.

- `name` - default: `"consul"`.
- `consul_version` - default: `"1.10.3"`.
- `consul_datacenter` - default: `"dc1"`.
- `key_filename` - default: `"id_rsa.pub"`.
- `region` - default: `"eu-central-1"`.
- `size` - default: `"small"`.
- `amount` - default: `3`.
- `aws_vpc_cidr_block_start` - default `"172.16"`.
- `tags` - default `{owner = "unset"}`.
- `max_instance_lifetime` - default `86400`. (1 day)
- `vpc_id` - default `""`.
- `service_cidr_blocks` - default `[0.0.0.0/0]`.

## Deployment

## Variables

Some more details about the variables below.

### name

The `name` is used in nearly any resource.

You can't change this value after a deployment is done, without loosing service.

### consul_version

This determines the version of Consul to install. Pick a version from [this](https://releases.hashicorp.com/consul/) list.

Changing this value after the cluster has been deployed has effect after:

- The `max_instance_lifetime` has passed and a instance is replaced.
- Manually triggering an instance refresh in the AWS console.

### size

The `size` variable makes is a little simpler to pick a size for the Consul cluster. For example `small` is the smallest size as recommended in the HashiCorp Consul reference architecture.

Changing this value after the cluster has been deployed has effect after:

- The `max_instance_lifetime` has passed and a instance is replaced.
- Manually triggering an instance refresh in the AWS console.

The `size`: `development` should be considered non-production:

- It's smaller than the HashiCorp Consul reference architecture recommends.
- It's using spot instances, which may be destroyed on price increases.

### amount

The `amount` of machines that make up the cluster can be changed. Use `3` or `5`.

Changes to the `amount` variable have immediate effect, without refreshing the instances.

### vpc_id

If you have an existing VPC, you can deploy this Consul installation in that VPC by setting this variable. The default is `""`, which means this code will create (and manage) a VPC (and all it's dependencies) for you.

Things that will be deployed when not specifying a VPC:

- `aws_vpc`
- `aws_internet_gateway`
- `aws_route_table`
- `aws_route`
- `aws_subnet`
- `aws_route_table_association`

When you do provide a value for the variable `vpc_id`, it should have:

- A subnet for all availability zones.
- An internet gateway and all routing to the internet setup.

You can't change this value after a deployment is done, without loosing service.

### max_instance_lifetime

Instance of the autoscale group will be destroyed and recreated after this value in seconds. This ensures you are using a "new" instance every time and you are not required to patch the instances, they will be recreated instead with the most recent image.

## Cost

To understand the cost for this service, you can use cost.modules.tf:

```shell
terraform apply
terraform state pull | curl -s -X POST -H "Content-Type: application/json" -d @- https://cost.modules.tf/
```
