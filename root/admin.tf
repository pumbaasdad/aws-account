resource aws_iam_user admin {
  name          = "admin"
  force_destroy = true
}

locals {
  admin_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    aws_iam_policy.administer_system_restore.arn
  ]
}

resource aws_iam_user_policy_attachment admin {
  count      = length(local.admin_policy_arns)
  policy_arn = element(local.admin_policy_arns, count.index)
  user       = aws_iam_user.admin.name
}
