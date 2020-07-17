provider aws {
  region = "us-east-1"
}

data aws_caller_identity current {}

resource aws_iam_user terraform {
  name          = "terraform"
  force_destroy = true
}

resource aws_iam_policy terraform_manage_users {
  name        = "terraform-manage-users"
  description = "Permissions required for the terraform IAM user to manage IAM users."
  policy      = <<EOF
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
                "iam:GetUserPolicy",
                "iam:AttachUserPolicy",
                "iam:CreateUser",
                "iam:DeleteAccessKey",
                "iam:DeleteLoginProfile",
                "iam:DeleteUser",
                "iam:DeleteUserPolicy",
                "iam:DetachUserPolicy",
                "iam:PutUserPolicy"
            ],
            "NotResource": [
              "${aws_iam_user.terraform.arn}"
            ]
        },
        {
            "Sid": "ListVirtualMFADevices",
            "Effect": "Allow",
            "Action": [
                "iam:ListVirtualMFADevices"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource aws_iam_policy terraform_manage_policies {
  name        = "terraform-manage-policies"
  description = "Permissions required for the terraform IAM user to manage IAM policies."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManagePolicies",
            "Effect": "Allow",
            "Action": [
                "iam:ListPolicyVersions",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:CreatePolicy",
                "iam:CreatePolicyVersion",
                "iam:DeletePolicy",
                "iam:DeletePolicyVersion"
            ],
            "NotResource": [
                "${aws_iam_policy.terraform_manage_users.arn}",
                "arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:policy/terraform-manage-policies",
                "${aws_iam_policy.terraform_manage_sns.arn}",
                "${aws_iam_policy.terraform_manage_cloudwatch.arn}"
            ]
        }
    ]
}
EOF
}

resource aws_iam_policy terraform_manage_sns {
  name        = "terraform-manage-sns"
  description = "Permissions required for the terraform IAM user to manage SNS."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManageSNS",
            "Effect": "Allow",
            "Action": [
                "sns:ListTagsForResource",
                "sns:GetTopicAttributes",
                "sns:CreateTopic",
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

resource aws_iam_policy terraform_manage_cloudwatch {
  name        = "terraform-manage-cloudwatch"
  description = "Permissions required for terraform IAM user to manage Cloudwatch."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManageCloudwatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListTagsForResource",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DeleteAlarms",
                "cloudwatch:PutMetricAlarm"
            ],
            "Resource": [
              "arn:aws:cloudwatch:us-east-1:${data.aws_caller_identity.current.account_id}:alarm:billing-alarm"
            ]
        }
    ]
}
EOF
}

resource aws_iam_policy terraform_manage_organizations {
  name        = "terraform-manage-organizations"
  description = "Permissions required by the terraform IAM user to manage organizations."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ManageOrganizations",
            "Effect": "Allow",
            "Action": [
                "organizations:ListAccounts",
                "organizations:ListAWSServiceAccessForOrganization",
                "organizations:ListParents",
                "organizations:ListRoots",
                "organizations:ListTagsForResource",
                "organizations:ListTargetsForPolicy",
                "organizations:DescribeAccount",
                "organizations:DescribeCreateAccountStatus",
                "organizations:DescribeOrganization",
                "organizations:DescribePolicy",
                "organizations:AttachPolicy",
                "organizations:CreateAccount",
                "organizations:CreateOrganization",
                "organizations:CreatePolicy",
                "organizations:DeletePolicy",
                "organizations:DetachPolicy",
                "organizations:EnablePolicyType",
                "organizations:UpdatePolicy",
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource aws_iam_policy terraform-manage_account {
  name        = "terraform-manage-account"
  description = "Permissions required for the terraform IAM user to manage the AWS account."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
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

locals {
  terraform_policy_arns = [
    aws_iam_policy.terraform_manage_cloudwatch.arn,
    aws_iam_policy.terraform_manage_policies.arn,
    aws_iam_policy.terraform_manage_sns.arn,
    aws_iam_policy.terraform_manage_users.arn,
    aws_iam_policy.terraform_manage_organizations.arn,
    aws_iam_policy.terraform-manage_account.arn
  ]
}

resource aws_iam_user_policy_attachment terraform_policy {
  count      = length(local.terraform_policy_arns)
  policy_arn = element(local.terraform_policy_arns, count.index)
  user       = aws_iam_user.terraform.name
}