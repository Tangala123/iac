locals {
  azs_names = data.aws_availability_zones.azs.names
  account_id = data.aws_caller_identity.current.account_id
  ws = terraform.workspace == "default" ? "dev" : terraform.workspace
}