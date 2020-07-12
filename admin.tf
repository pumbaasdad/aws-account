resource aws_iam_user admin {
  name          = "admin"
  force_destroy = true
}

resource aws_iam_group admin {
  name = aws_iam_user.admin.name
}

resource aws_iam_group_policy_attachment admin {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource aws_iam_group_membership admin {
  group = aws_iam_group.admin.name
  name  = "${aws_iam_group.admin.name}-membership"
  users = [
    aws_iam_user.admin.name
  ]
}
