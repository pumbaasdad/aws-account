resource aws_iam_user terraform_permissions {
  name          = "terraform-permissions"
  force_destroy = true
}

resource aws_iam_policy manage_terraform_user {
  name        = "manage-terraform-user"
  description = "Permissions required for the terraform-permissions IAM user to manage the terraform IAM user."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManageTerraformUser",
            "Effect": "Allow",
            "Action": [
                "iam:ListAccessKeys",
                "iam:ListAttachedUserPolicies",
                "iam:ListGroupsForUser",
                "iam:ListMFADevices",
                "iam:ListSigningCertificates",
                "iam:ListSSHPublicKeys",
                "iam:ListUserPolicies",
                "iam:GetUser",
                "iam:AttachUserPolicy",
                "iam:CreateUser",
                "iam:DeleteAccessKey",
                "iam:DeleteLoginProfile",
                "iam:DeleteUser",
                "iam:DetachUserPolicy",
                "iam:UpdateUser"
            ],
            "Resource": [
                "${data.aws_caller_identity.current.arn}"
            ]
        }
    ]
}
EOF
}

locals {
  terraform_permissions_manage_policies_name = "terraform-permissions-manage-policies"
}

resource aws_iam_policy terraform_permissions_manage_policies {
  name        = local.terraform_permissions_manage_policies_name
  description = "Permissions required for the terraform-permissions IAM role to manage IAM policies."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
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
                "iam:DeletePolicy",
                "iam:ListVirtualMFADevices"
            ],
            "NotResource": ${jsonencode(local.terraform_permissions_policy_arns)}
        }
    ]
}
EOF
}

locals {
  terraform_permissions_policy_arns = [
    aws_iam_policy.manage_terraform_user.arn,
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.terraform_permissions_manage_policies_name}",
  ]
}

resource aws_iam_user_policy_attachment terraform_permissions {
  count      = length(local.terraform_permissions_policy_arns)
  policy_arn = element(local.terraform_permissions_policy_arns, count.index)
  user       = aws_iam_user.terraform_permissions.name
}
