# Default scenario for Consul

Spin up a HashiCorp Consul cluster that automatically joins members based on AWS tags.

## Setup

```shell
terraform init
test -f id_rsa.pub || ssh-keygen -f id_rsa
```

## Deploying

```shell
terraform apply
```

You will see the IP address of the bastion-host.

```shell
ssh-add id_rsa
ssh ec2-user@BASTION_HOST
```

## Testing

if `size` is set to `development`, 2 Consul agents will be started and connected. If all is well, you should be able to:

- `dig @HOSTNAME_OF_LOADBALANCER -p 8600 httpd.service.dc1.consul.`
