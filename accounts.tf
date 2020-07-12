resource aws_organizations_organization organization {
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"
  ]
}

resource aws_organizations_account system_restore {
  name                       = "system-restore"
  email                      = var.system_restore_email
}

resource aws_organizations_policy iam {
  name    = "manage-iam"
  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Sid": "ManageUsers",
            "Effect": "Allow",
            "Action": [
                "iam:CreateUser",
                "iam:GetUser",
                "iam:DeleteUser",
                "iam:DeleteAccessKey",
                "iam:ListAccessKeys",
                "iam:ListSSHPublicKeys",
                "iam:ListMFADevices",
                "iam:DeleteLoginProfile",
                "iam:ListSigningCertificates",
                "iam:ListVirtualMFADevices"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ManageGroups",
            "Effect": "Allow",
            "Action": [
                "iam:CreateGroup",
                "iam:AddUserToGroup",
                "iam:GetGroup",
                "iam:DeleteGroup",
                "iam:AttachGroupPolicy",
                "iam:DetachGroupPolicy",
                "iam:RemoveUserFromGroup",
                "iam:ListGroupsForUser"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ManagePolicies",
            "Effect": "Allow",
            "Action": [
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:ListAttachedGroupPolicies",
                "iam:CreatePolicy",
                "iam:ListPolicyVersions",
                "iam:CreatePolicyVersion",
                "iam:DeletePolicyVersion",
                "iam:DeletePolicy"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ManageAccount",
            "Effect": "Allow",
            "Action": [
                "iam:CreateAccountAlias",
                "iam:ListAccountAliases",
                "iam:DeleteAccountAlias"
            ],
            "Resource": "*"
        }
  ]
}
EOF
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
    aws_organizations_policy.iam.id,
    aws_organizations_policy.system_restore.id,
  ]
}

resource aws_organizations_policy_attachment system_restore {
  count     = length(local.system_restore_organization_policy_ids)
  policy_id = element(local.system_restore_organization_policy_ids, count.index)
  target_id = aws_organizations_account.system_restore.id
}
