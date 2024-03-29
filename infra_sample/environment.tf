locals {
  root                 = "../"                       # Path to root of repo
  yaml_config_path     = "../infra-config.yml"         # Required settings
  #secrets_folder       = "../.secrets"                 # Default secrets location
  #aws_credentials_file = "../.secrets/aws-credentials" # AWS Credentials
}

data "local_file" "config_yml" { filename = local.yaml_config_path }
locals {
  config            = yamldecode(data.local_file.config_yml.content)
  project_shortname = local.config["project_shortname"]
  aws_region        = local.config["aws_region"]
  resource_tags     = local.config["resource_tags"]
  name_prefix       = "${local.project_shortname}-"
}

provider "aws" {
  version                 = "~> 2.10"
  region                  = local.aws_region
  #shared_credentials_file = local.aws_credentials_file
  profile                 = "new-profile"
}
