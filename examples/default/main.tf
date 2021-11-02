# Call the module.
module "consul" {
  source = "../../"
  size   = "development"
  tags = {
    owner = "robertdebock"
  }
}
