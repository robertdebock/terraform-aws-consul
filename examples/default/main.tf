# Call the module.
module "consul" {
  source                       = "../../"
  launch_configuration_version = 1
  size                         = "development"
  tags = {
    owner = "robertdebock"
  }
}
