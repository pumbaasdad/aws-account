resource tfe_workspace system_restore_terraform_permissions {
  count             = local.system_restore_count
  name              = "system-restore-terraform-permissions"
  organization      = var.terraform_cloud_organization
  working_directory = "terraform/terraform-permissions"

  vcs_repo {
    identifier     = "${var.github_user}/system-restore"
    oauth_token_id = var.github_token
  }
}

resource tfe_variable system_restore_terraform_permissions_role {
  count       = local.system_restore_count
  key          = "role"
  value        = ""
  category     = "terraform"
  workspace_id = tfe_workspace.system_restore_terraform_permissions[count.index].id
  description  = "The role that Terraform Cloud will assume to deploy terraform permissions to the system-restore AWS sub-account."

  lifecycle {
    ignore_changes = [value]
  }
}

resource tfe_variable system_restore_terraform_permissions_aws_access_key_id {
  count        = local.system_restore_count
  key          = "AWS_ACCESS_KEY_ID"
  value        = ""
  category     = "env"
  workspace_id = tfe_workspace.system_restore_terraform_permissions[count.index].id
  description  = "The AWS_ACCESS_KEY_ID used by terraform to deploy terraform permissions to the system-restore AWS sub-account."

  lifecycle {
    ignore_changes = [value]
  }
}

resource tfe_variable system_restore_terraform_permissions_aws_secret_access_key {
  count        = local.system_restore_count
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = ""
  category     = "env"
  workspace_id = tfe_workspace.system_restore_terraform_permissions[count.index].id
  description  = "The SECRET_ACCESS_KEY used by terraform to deploy terraform permissions to the system-restore AWS sub-account."
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource tfe_run_trigger run_system_restore_terraform_permissions_after_terraform_cloud {
  count         = local.system_restore_count
  workspace_id  = tfe_workspace.system_restore_terraform_permissions[count.index].id
  sourceable_id = data.tfe_workspace.terraform_cloud.id
}

resource tfe_run_trigger run_system_restore_terraform_permissions_after_root {
  count         = local.system_restore_count
  workspace_id  = tfe_workspace.system_restore_terraform_permissions[count.index].id
  sourceable_id = tfe_workspace.root.id
}