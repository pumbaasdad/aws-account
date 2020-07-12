variable account_alias {
  type        = string
  description = "An alias for your root AWS account ID.  It must start with an alphanumeric character and only contain lowercase alphanumeric characters and hyphens."
}

variable charge_warning_dollars {
  type        = number
  description = "The number of Canadian dollars spent in the AWS account in a month that will trigger a warning notification to be sent.  AWS will evaluate the estimated charges every 6 hours."
}

variable system_restore_email {
  type        = string
  description = "Email address of the owner of the system-restore AWS sub-account."
}

variable terraform_cloud_organization {
  type        = string
  description = "The name of your Terraform Cloud organization."
}

variable github_user {
  type        = string
  description = "The name of the github account that owns your repository forks."
}

variable github_token {
  type        = string
  description = "A github OAuth token that will allow terraform cloud to access your repository forks."
}