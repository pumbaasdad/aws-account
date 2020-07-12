resource aws_iam_policy manage_users {
  name        = "manage-users"
  description = "Permissions required to manage IAM users."
  policy      = <<EOF
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
                "iam:ListSigningCertificates"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource aws_iam_policy manage_groups {
  name        = "manage-groups"
  description = "Permissions required to manage IAM groups."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
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
        }
    ]
}
EOF
}

resource aws_iam_policy manage_policies {
  name        = "manage-policies"
  description = "Permissions required to manage IAM policies."
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
            "Resource": "*"
        }
    ]
}
EOF
}

resource aws_iam_policy manage_account {
  name        = "manage-account"
  description = "Permissions required to manage the AWS account."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
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

resource aws_iam_policy manage_sns {
  name        = "manage-sns"
  description = "Permissions required to manage SNS."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManageSNS",
            "Effect": "Allow",
            "Action": [
                "sns:GetTopicAttributes",
                "sns:CreateTopic",
                "sns:ListTagsForResource",
                "sns:DeleteTopic"
            ],
            "Resource": [
                "arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:notify-me"
            ]
        }
    ]
}
EOF
}

resource aws_iam_policy manage_cloudwatch {
  name        = "manage-cloudwatch"
  description = "Permissions required to manage Cloudwatch."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManageCloudwatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:ListTagsForResource",
                "cloudwatch:DeleteAlarms"
            ],
            "Resource": [
              "arn:aws:cloudwatch:us-east-1:${data.aws_caller_identity.current.account_id}:alarm:billing-alarm"
            ]
        }
    ]
}
EOF
}

resource aws_iam_policy manage_organizations {
  name        = "manage-organizations"
  description = "Permissions required to manage organizations."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManageOrganizations",
            "Effect": "Allow",
            "Action": [
                "organizations:CreateAccount",
                "organizations:CreateOrganization",
                "organizations:DescribeOrganization",
                "organizations:ListAccounts",
                "organizations:ListRoots",
                "organizations:ListAWSServiceAccessForOrganization",
                "organizations:DescribeCreateAccountStatus",
                "organizations:DescribeAccount",
                "organizations:ListParents",
                "organizations:ListTagsForResource",
                "organizations:AttachPolicy",
                "organizations:CreatePolicy",
                "organizations:EnablePolicyType",
                "organizations:UpdatePolicy",
                "organizations:DescribePolicy",
                "organizations:ListTargetsForPolicy",
                "organizations:DetachPolicy",
                "organizations:DeletePolicy",
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*"
        }
    ]
}
EOF
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