resource tfe_workspace system_restore {
  name              = "system-restore"
  organization      = var.terraform_cloud_organization
  working_directory = "terraform"

  vcs_repo {
    identifier     = "${var.github_user}/system-restore"
    oauth_token_id = var.github_token
  }
}

resource tfe_variable system_restore_role {
  key          = "role"
  value        = "arn:aws:iam::${aws_organizations_account.system_restore.id}:role/OrganizationAccountAccessRole"
  category     = "terraform"
  workspace_id = tfe_workspace.system_restore.id
  description  = "The role that Terraform Cloud will assume to deploy resources to the system-restore AWS account."
}

resource tfe_variable system_restore_alias {
  key          = "account_alias"
  value        = "${var.account_alias}-system-restore"
  category     = "terraform"
  workspace_id = tfe_workspace.system_restore.id
  description  = "The alias of the AWS system-restore sub-account."
}
