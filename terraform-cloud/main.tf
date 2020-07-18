provider tfe {}

variable account_alias {
  type        = string
  description = "An alias for your root AWS account ID.  It must start with an alphanumeric character and only contain lowercase alphanumeric characters and hyphens."
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