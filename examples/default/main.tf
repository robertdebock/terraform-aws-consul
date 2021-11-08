# Call the module.
module "consul" {
  source         = "../../"
  size           = "development"
  amount         = "3"
  # consul_version = "1.9.0"
  # vpc_id       = "vpc-04c93b3fa696a2d21"
  # bastion_host = false
  tags = {
    owner = "robertdebock"
  }
}
