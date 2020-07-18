resource aws_iam_user admin {
  name          = "admin"
  force_destroy = true
}

resource aws_iam_user_policy_attachment admin_admin_policy_attachment {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  user       = aws_iam_user.admin.name
}

resource aws_iam_user_policy_attachment admin_administer_system_restore_policy_attachment {
  count      = local.system_restore_count
  policy_arn = aws_iam_policy.administer_system_restore[count.index].arn
  user       = aws_iam_user.admin.name
}
