variable use_system_restore {
  type        = bool
  default     = false
  description = "If the system-restore workspace should be created and managed."
}

locals {
  system_restore_count = var.use_system_restore ? 1 : 0
}

resource tfe_workspace system_restore {
  count             = local.system_restore_count
  name              = "system-restore"
  organization      = var.terraform_cloud_organization
  working_directory = "terraform"

  vcs_repo {
    identifier     = "${var.github_user}/system-restore"
    oauth_token_id = var.github_token
  }
}

resource tfe_variable system_restore_role {
  count       = local.system_restore_count
  key          = "role"
  value        = ""
  category     = "terraform"
  workspace_id = tfe_workspace.system_restore[count.index].id
  description  = "The role that Terraform Cloud will assume to deploy resources to the system-restore AWS account."

  lifecycle {
    ignore_changes = [value]
  }
}

resource tfe_variable system_restore_alias {
  count        = local.system_restore_count
  key          = "account_alias"
  value        = "${var.account_alias}-system-restore"
  category     = "terraform"
  workspace_id = tfe_workspace.system_restore[count.index].id
  description  = "The alias of the AWS system-restore sub-account."
}