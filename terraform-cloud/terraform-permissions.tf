resource tfe_workspace terraform_permissions {
  name              = "terraform-permissions"
  organization      = var.terraform_cloud_organization
  working_directory = "terraform-permissions"

  vcs_repo {
    identifier     = "${var.github_user}/aws-account"
    oauth_token_id = var.github_token
  }
}

resource tfe_variable terraform_permissions_aws_access_key_id {
  key          = "AWS_ACCESS_KEY_ID"
  value        = ""
  category     = "env"
  workspace_id = tfe_workspace.terraform_permissions.id
  description  = "The AWS_ACCESS_KEY_ID used by terraform to deploy policies and groups to the root AWS account."

  lifecycle {
    ignore_changes = [value]
  }
}

resource tfe_variable terraform_permissions_aws_secret_access_key {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = ""
  category     = "env"
  workspace_id = tfe_workspace.terraform_permissions.id
  description  = "The SECRET_ACCESS_KEY used by terraform to deploy policies and groups to the root AWS account."
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}
