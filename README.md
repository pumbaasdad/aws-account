This project contains the terraform required to create the AWS accounts needed for the follow projects:

 1. [system-restore](https://github.com/pumbaasdad/system-restore)
 
All attempts have been made to keep the costs associated with this project low and to provide as much security as
possible, however you are ultimately responsible for understanding what is being deployed, and any costs or security
risks that are associated with those resources.

All instructions provided with this repository assume that you are using [Terraform Cloud](terraform.io).  The terraform
should work if run manually, however all testing has been done with Terraform Cloud.

# Managed Resources

The terraform in this project manages the following resources:

 * The alias for your AWS account
 * IAM Policies
   * `manage-users` - Allow IAM users to be added and deleted from the account.
   * `manage-groups` - Allow IAM groups to be created and deleted from the account.  Allow policy to be attached to
                       groups.
   * `manage-policies` - Allow IAM policies to be created and destroyed in the account.
   * `manage-account` - Allow the account alias to be changed. 
   * `manage-sns` - Allow SNS topics to be created and destroyed.
   * `manage-cloudwatch` - Allow metric alarms to be created and destroyed.
   * `manage-organizations` - Allow organizations and sub-accounts to be created.  Allow organization policies to be
                              created, attached, updated and destroyed.  This policy does not allow for the deletion of
                              organizations or accounts.
   * `administer-system-restore` - Allows the `OrganizationAccountAccessRole` to be assumed in the `system-restore`
                                   sub-account.
 * IAM Groups
   * `<account alias>-admin` - A group for account administrators.  It contains the following policies:
     * `manage-users`
     * `manage-groups`
     * `manage-policies`
     * `manage-account`
     * `manage-sns`
     * `manage-cloudwatch`
     * `manage-organizations`
     * `administer-system-restore`
 * IAM Users
   * `<account alias>-admin` - The IAM user that will run the terraform after the account has been bootstrapped using
                               root credentials.  This user belongs to the following groups:
     * `<account alias>-admin`
 * SNS Topic
   * `notify-me` - A topic that will be used to send you notifications about your account.  You must manually create a
                   subscription to the topic.
 * Cloudwatch Alarms
   * `billing-alarm` - An alarm that will be triggered when the estimated AWS charges for the month exceed the
                       configured limit.  The `notify-me` SNS topic will be notified when this alarm is triggered.
 * AWS Organization - An organization is created within the account.
 * Service Control Policies
   * `manage-iam` - A service control policy that will allow IAM users, groups and policies to be created, updated and
                    deleted.  It allows users to be added to groups, and for policies to be attached or removed from
                    groups.  It also allows the account alias to be changed.
   * `system-restore` - Allows policies required by the `system-restore` project.  Specifically, full control over the
                        SSM parameter store, and the ability to encrypt and decrypt using KMS keys.
 * AWS Sub-Accounts
   * `system-restore` - An account in which the `system-restore` project can be run.  The `manage-iam` and
                        `system-restore` service control policies are attached.  If the default service control policy
                        is detached, it should not be possible to do anything in this account that isn't expressly
                        required by the `system-restore project`. 

# Initial Setup

 1. Create an AWS account ([instructions](https://tinyurl.com/y7aq2ky5)).
 1. Create AWS root access keys
    1. Navigate [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials).
    1. Expand `Access keys`.
    1. Click `Create New Access Key`.
    1. Click `Show Access Key` and ake note of the new access key ID and secret access key.
 1. Click `Receive Billing Alerts` [here](https://console.aws.amazon.com/billing/home?#/preferences).
 1. Fork this repository for use with Terraform Cloud.
 1. Setup Terraform Cloud account ([instructions](https://tinyurl.com/y8ph3b5r)).
    1. Create a new account.
    1. Create a new organization.
    1. Create a workspace.
        1. Give the organization access to your fork of this repository.
        1. Configure Variables
            1. Terraform Variables
                1. `charge_warning_dollars` - The number of Canadian dollars spent in the AWS account in a month that
                                              will trigger a warning notification to be sent.  AWS will evaluate the
                                              estimated charges every 6 hours.
                1. `account_alias` - An alias for your AWS account ID.  It must start with an alphanumeric character and
                                     only contain lowercase alphanumeric characters and hyphens.
                1. `system_restore_email` - Email address of the owner of the system-restore AWS sub-account.  This
                                            must be different from the e-mail address used with your root account.
            1. Environment Variables
                1. `AWS_ACCESS_KEY_ID` - The root access key ID generated earlier.
                1. `AWS_SECRET_ACCESS_KEY` - The root secret access key generated when creating the AWS account.  This
                                             variable should be marked `sensitive`.
 1. Apply the terraform to setup your AWS account.
    1. In Terraform Cloud, click the `Queue plan` button.
    1. When the plan completes, click the `Confirm & Apply` button.
 1. Approve the AWS Organizations email verification request that AWS sends you.
 1. Detach the default Service Control Policy on the `system-restore` AWS account. 
    1. Navigate [here](https://console.aws.amazon.com/organizations/home?region=us-east-1#/accounts)
    1. Select `system-restore`.
    1. Click `Service control policies`.
    1. CLick `Detach` beside `FullAWSAccess`.
 1. Subscribe to AWS billing alert alarms.
    1. Navigate [here](https://console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics)
    1. Click `notify-me`.
    1. Click `Create subscription`.
    1. Subscribe.
        1. Set Protocol to `Email`
        1. Set Endpoint to your e-mail address.
        1. Click `Create subscription`.
        1. Confirm the subscription e-mail that arrives in your inbox.
 1. Create access keys for the AWS `<account-alias>-admin` user.
    1. Navigate [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/users).
    1. Click on the admin user.
    1. Click `Create access key`.
    1. Make note of the `Access key ID` and `Secret access key`.
 1. Update the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables in your Terraform Cloud workspace
    to be the key's created for the AWS admin user.
 1. Delete your root access keys.
    1. Navigate [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials).
    1. Expand `Access keys`.
    1. Click `Delete` next to your access key.
    1. Confirm by clicking `Yes`.

# Keeping Account Up To Date

Every time changes are delivered to the main branch of your fork, Terraform Cloud will automatically run a plan.  You
must log in to Terraform Cloud and Confirm and Apply the changes.  You may also choose to automatically apply successful
plans.

Because the admin IAM user (that is being used by Terraform Cloud) has restricted permissions, if the changes delivered
to your main branch contain resource changes, and permission updates required to apply those changes, terraform may
fail to update your resources.  In this case, the permissions should have been updated.  Rerunning and applying the plan
should then update the resources.

# Destroying Resources

Because terraform manages the user that is used to run terraform, attempting to use Terraform Cloud to run
`terraform destory` will fail (the admin user will lose permissions to delete users before it deletes itself).
Therefore, to accomplish this, you must first create new root account keys and update Terraform Cloud to use them.

Destroying resources will remove the association between your root account and any sub-accounts, however the
sub-accounts will still exist.  Make sure you understand how to manage or close those accounts before running destorying
resources.