resource aws_organizations_organization organization {
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"
  ]
}

resource aws_organizations_policy manage_iam {
  name    = "manage-iam"
  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Sid": "ManageUsers",
            "Effect": "Allow",
            "Action": [
                "iam:ListAccessKeys",
                "iam:ListAttachedUserPolicies",
                "iam:ListGroupsForUser",
                "iam:ListMFADevices",
                "iam:ListSigningCertificates",
                "iam:ListSSHPublicKeys",
                "iam:ListUserPolicies",
                "iam:ListVirtualMFADevices",
                "iam:GetUser",
                "iam:CreateUser",
                "iam:DeleteAccessKey",
                "iam:DeleteLoginProfile",
                "iam:DeleteUser"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ManageGroups",
            "Effect": "Allow",
            "Action": [
                "iam:ListAttachedGroupPolicies",
                "iam:ListGroupPolicies",
                "iam:ListGroups",
                "iam:GetGroup",
                "iam:AddUserToGroup",
                "iam:AttachGroupPolicy",
                "iam:CreateGroup",
                "iam:DeleteGroup",
                "iam:DetachGroupPolicy",
                "iam:RemoveUserFromGroup",
                "iam:UpdateGroup"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ManagePolicies",
            "Effect": "Allow",
            "Action": [
                "iam:ListPolicyVersions",
                "iam:ListAttachedGroupPolicies",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:CreatePolicy",
                "iam:CreatePolicyVersion",
                "iam:DeletePolicy",
                "iam:DeletePolicyVersion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ManageRoles",
            "Effect": "Allow",
            "Action": [
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:GetRole",
                "iam:AttachRolePolicy",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:DetachRolePolicy",
                "iam:UpdateAssumeRolePolicy",
                "iam:UpdateRole",
                "iam:UpdateRoleDescription"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ManageAccount",
            "Effect": "Allow",
            "Action": [
                "iam:ListAccountAliases",
                "iam:CreateAccountAlias",
                "iam:DeleteAccountAlias"
            ],
            "Resource": "*"
        },
        {
            "Sid": "InterrogateOrganization",
            "Effect": "Allow",
            "Action": [
              "organizations:DescribeOrganization"
            ],
            "Resource": "*"
        }
  ]
}
EOF
}
