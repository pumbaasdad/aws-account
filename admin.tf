resource aws_iam_user admin {
  name          = "${var.account_alias}-admin"
  force_destroy = true
}

resource aws_iam_group admin {
  name = aws_iam_user.admin.name
}

locals {
  admin_policy_arns = [
    aws_iam_policy.manage_organizations.arn,
    aws_iam_policy.manage_account.arn,
    aws_iam_policy.manage_sns.arn,
    aws_iam_policy.manage_cloudwatch.arn,
    aws_iam_policy.manage_users.arn,
    aws_iam_policy.manage_groups.arn,
    aws_iam_policy.manage_policies.arn,
    aws_iam_policy.administer_system_restore.arn
  ]
}

resource aws_iam_group_policy_attachment admin_policies {
  count      = length(local.admin_policy_arns)
  group      = aws_iam_group.admin.name
  policy_arn = element(local.admin_policy_arns, count.index)
}

resource aws_iam_group_membership admin {
  group = aws_iam_group.admin.name
  name  = "${aws_iam_group.admin.name}-membership"
  users = [
    aws_iam_user.admin.name
  ]
}
