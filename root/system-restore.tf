locals {
  system_restore_count = var.use_system_restore ? 1 : 0
}

resource aws_organizations_account system_restore {
  count = local.system_restore_count
  name  = "system-restore"
  email = var.system_restore_email
}

resource aws_organizations_policy system_restore {
  count   = local.system_restore_count
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
  system_restore_organization_policy_ids = var.use_system_restore ? [
    aws_organizations_policy.manage_iam.id,
    aws_organizations_policy.system_restore[0].id,
  ] : []
}

resource aws_organizations_policy_attachment system_restore {
  count     = length(local.system_restore_organization_policy_ids)
  policy_id = element(local.system_restore_organization_policy_ids, count.index)
  target_id = aws_organizations_account.system_restore[0].id
}

resource aws_iam_policy administer_system_restore {
  count       = local.system_restore_count
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
            "Resource": "arn:aws:iam::${aws_organizations_account.system_restore[count.index].id}:role/OrganizationAccountAccessRole"
        }
    ]
}
EOF
}

resource aws_iam_policy deploy_system_restore {
  count       = local.system_restore_count
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
            "Resource": "arn:aws:iam::${aws_organizations_account.system_restore[count.index].id}:role/terraform"
        }
    ]
}
EOF
}
resource aws_iam_policy deploy_system_restore_deploy_permissions {
  count       = local.system_restore_count
  name        = "deploy-system-restore-deploy-permissions"
  description = "Permissions required to assume the terraform-permissions role in the system-restore account."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DeploySystemRestoreDeployPermissions",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${aws_organizations_account.system_restore[count.index].id}:role/terraform-permissions"
        }
    ]
}
EOF
}

resource aws_iam_user system_restore_terraform {
  count         = local.system_restore_count
  name          = "system-restore-terraform"
  force_destroy = true
}

resource aws_iam_user_policy_attachment system_restore_terraform {
  count      = local.system_restore_count
  policy_arn = aws_iam_policy.deploy_system_restore[count.index].arn
  user       = aws_iam_user.system_restore_terraform[count.index].name
}

resource aws_iam_user system_restore_terraform_permissions {
  count         = local.system_restore_count
  name          = "system-restore-terraform-permissions"
  force_destroy = true
}

resource aws_iam_user_policy_attachment system_restore_terraform_permissions {
  count      = local.system_restore_count
  policy_arn = aws_iam_policy.deploy_system_restore_deploy_permissions[count.index].arn
  user       = aws_iam_user.system_restore_terraform_permissions[count.index].name
}