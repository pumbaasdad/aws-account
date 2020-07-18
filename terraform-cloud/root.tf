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
  count        = local.system_restore_count
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

resource tfe_variable use_system_restore {
  key          = "use_system_restore"
  value        = var.use_system_restore
  category     = "terraform"
  workspace_id = tfe_workspace.root.id
  description  = "If resources should be created/managed for the system-restore sub-account"
}