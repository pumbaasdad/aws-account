provider aws {
  region = "us-east-1"
}

data aws_caller_identity current {}

resource aws_iam_account_alias account_alias {
  account_alias = var.account_alias
}

provider tfe {}