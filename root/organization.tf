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
                "iam:GetUser",
                "iam:AttachUserPolicy",
                "iam:CreateUser",
                "iam:DeleteAccessKey",
                "iam:DeleteLoginProfile",
                "iam:DeleteUser",
                "iam:DetachUserPolicy"
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
                "iam:DeletePolicy",
                "iam:ListVirtualMFADevices"
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
        }
  ]
}
EOF
}
