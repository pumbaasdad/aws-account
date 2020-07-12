resource aws_iam_user terraform {
  name          = "terraform"
  force_destroy = true
}

resource aws_iam_group terraform {
  name = aws_iam_user.terraform.name
}

locals {
  terraform_policy_arns = [
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

resource aws_iam_group_policy_attachment terraform {
  count      = length(local.terraform_policy_arns)
  group      = aws_iam_group.terraform.name
  policy_arn = element(local.terraform_policy_arns, count.index)
}

resource aws_iam_group_membership terraform {
  group = aws_iam_group.terraform.name
  name  = "${aws_iam_group.terraform.name}-membership"
  users = [
    aws_iam_user.terraform.name
  ]
}
