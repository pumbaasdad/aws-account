resource aws_organizations_account system_restore {
  name                       = "system-restore"
  email                      = var.system_restore_email
}

resource aws_organizations_policy system_restore {
  name    = "system-restore"
  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Sid": "ManageParameters",
            "Effect": "Allow",
            "Action": [
                "ssm:PutParameter",
                "ssm:LabelParameterVersion",
                "ssm:DeleteParameter",
                "ssm:DescribeParameters",
                "ssm:RemoveTagsFromResource",
                "ssm:GetParameterHistory",
                "ssm:AddTagsToResource",
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:DeleteParameters",
                "kms:Encrypt",
                "kms:Decrypt"
            ],
            "Resource": "*"
        }
  ]
}
EOF
}

locals {
  system_restore_organization_policy_ids = [
    aws_organizations_policy.manage_iam.id,
    aws_organizations_policy.system_restore.id,
  ]
}

resource aws_organizations_policy_attachment system_restore {
  count     = length(local.system_restore_organization_policy_ids)
  policy_id = element(local.system_restore_organization_policy_ids, count.index)
  target_id = aws_organizations_account.system_restore.id
}

resource aws_iam_policy administer_system_restore {
  name        = "administer-system-restore"
  description = "Permissions required to assume the administrator role in the system-restore account."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AdministerSystemRestore",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${aws_organizations_account.system_restore.id}:role/OrganizationAccountAccessRole"
        }
    ]
}
EOF
}

resource aws_iam_policy deploy_system_restore {
  name        = "deploy-system-restore"
  description = "Permissions required to assume the terraform role in the system-restore account."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DeploySystemRestore",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${aws_organizations_account.system_restore.id}:role/terraform"
        }
    ]
}
EOF
}

resource aws_iam_user system_restore_terraform {
  name          = "system-restore-terraform"
  force_destroy = true
}

resource aws_iam_user_policy_attachment system_restore_terraform {
  policy_arn = aws_iam_policy.deploy_system_restore.arn
  user       = aws_iam_user.system_restore_terraform.name
}