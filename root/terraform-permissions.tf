resource aws_iam_user terraform_permissions {
  name          = "terraform-permissions"
  force_destroy = true
}

resource aws_iam_user_policy terraform_permissions {
  name   = "${aws_iam_user.terraform_permissions.name}-policy"
  user   = aws_iam_user.terraform_permissions.name
  policy = <<EOF
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
        }
    ]
}
EOF
}