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