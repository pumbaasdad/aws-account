provider tfe {}

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

resource tfe_workspace root {
  name              = "root"
  organization      = var.terraform_cloud_organization
  working_directory = "root"

  vcs_repo {
    identifier     = "${var.github_user}/aws-account"
    oauth_token_id = var.github_token
  }
}

resource tfe_variable root_account_alias {
  key          = "account_alias"
  value        = var.account_alias
  category     = "terraform"
  workspace_id = tfe_workspace.root.id
  description  = "The alias of your AWS root account."
}

resource tfe_variable root_charge_warning_dollars {
  key          = "charge_warning_dollars"
  value        = 1
  category     = "terraform"
  workspace_id = tfe_workspace.root.id
  description  = "The number of US dollars spent in the AWS account in a month that will trigger a warning notification to be sent.  AWS will evaluate the estimated charges every 6 hours."

  lifecycle {
    ignore_changes = [value]
  }
}

resource tfe_variable root_system_restore_email {
  key          = "system_restore_email"
  value        = ""
  category     = "terraform"
  workspace_id = tfe_workspace.root.id
  description  = "Email address of the owner of the system-restore AWS sub-account."

  lifecycle {
    ignore_changes = [value]
  }
}

resource tfe_variable root_aws_access_key_id {
  key          = "AWS_ACCESS_KEY_ID"
  value        = ""
  category     = "env"
  workspace_id = tfe_workspace.root.id
  description  = "The AWS_ACCESS_KEY_ID used by terraform to deploy resources to the root AWS account."

  lifecycle {
    ignore_changes = [value]
  }
}

resource tfe_variable root_aws_secret_access_key {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = ""
  category     = "env"
  workspace_id = tfe_workspace.root.id
  description  = "The SECRET_ACCESS_KEY used by terraform to deploy resources to the root AWS account."
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

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
  value        = ""
  category     = "terraform"
  workspace_id = tfe_workspace.system_restore.id
  description  = "The role that Terraform Cloud will assume to deploy resources to the system-restore AWS account."

  lifecycle {
    ignore_changes = [value]
  }
}

resource tfe_variable system_restore_alias {
  key          = "account_alias"
  value        = "${var.account_alias}-system-restore"
  category     = "terraform"
  workspace_id = tfe_workspace.system_restore.id
  description  = "The alias of the AWS system-restore sub-account."
}