This project contains the terraform required to create the AWS accounts needed for the follow projects:

 1. [system-restore](https://github.com/pumbaasdad/system-restore)
 
All attempts have been made to keep the costs associated with this project low and to provide as much security as
possible, however you are ultimately responsible for understanding what is being deployed, and any costs or security
risks that are associated with those resources.

All instructions provided with this repository assume that you are using [Terraform Cloud](https://terraform.io).  The
terraform should work if run manually, however all testing has been done with Terraform Cloud.

# Managed Resources

## AWS

This project manages three different terraform root directories, each corresponding to a Terraform Cloud workspace.

### terraform-cloud

The terraform in the `terraform-cloud` directory manages all Terraform Cloud resources (except the `terraform-cloud`)
workspace itself.  It creates's the following workspaces and variables:

 * `terraform-permissions` - This workspace is used to give the `terraform` IAM user the permissions it needs to deploy
                           resources to the root account.
   * `AWS_ACCESS_KEY_ID` - The ID of the AWS access key the the `terraform-permissions` user will use to manage
                           resources in the root AWS account.  This value defaults to an empty string.
   * `AWS_SECRET_ACCESS_KEY` - The AWS secret access key  that the `terraform-permissions` user will use to manage
                               resources in the AWS root account.  This value defaults to an empty string.
 * `root` - This workspace is used to deploy resources to your AWS root account.
   * `change_warning_dollars` - The number of US dollars spent in the AWS account in a month that will trigger a warning
                                notification to be sent. AWS will evaluate the estimated charges every 6 hours.  This
                                value defaults to $1.
   * `account_alias` - The alias of the AWS root account.  This value defaults to an empty string.
   * `use_system_restore` - If resources related to the `system-restore` repository will be created.  This value
                            defaults to false.
   * `system_restore_email` - The e-mail address of the owner of the `system-restore` AWS sub-account.  This variable is
                              only created if the `use_system_restore` variable is set to true in the `terraform-cloud`
                              workspace and defaults to an empty string.
   * `AWS_ACCESS_KEY_ID` - The ID of the AWS access key the the `terraform` user will use to manage resources in the
                           root AWS account.  This value defaults to an empty string.
   * `AWS_SECRET_ACCESS_KEY` - The AWS secret access key  that the `terraform` user will use to manage resources in the
                               AWS root account.  This value defaults to an empty string.
 * `system-restore` - This workspace is used to manage resources in the `system-restore` AWS sub-account.  It is only
                      created if the `use_system_restore` variable is set to true.
   * `account_alias` - The alias of the `system-restore` AWS sub-account.  This value defaults to the value of the
                       `account_alias` variable in the `terraform-cloud` workspace followed by `-system-restore`.
   * `role` - The role that will be assumed by the `system-restore-terraform` user to deploy resources to the 
              `system-restore` AWS sub-account.  This value defaults to an empty string.
   * `AWS_ACCESS_KEY_ID` - The ID of the AWS access key the the `system-restore-terraform` user will use to manage
                           resources in the `system-restore` AWS sub-account.  This value defaults to an empty string.
   * `AWS_SECRET_ACCESS_KEY` - The AWS secret access key  that the `system-restore-terraform` user will use to manage
                               resources in the `system-restore` AWS sub-account.  This value defaults to an empty
                               string.
 * `system-restore-terraform-permissions` - This workspace is used to manage terraform permissions in the
                                            `system-restore` AWS sub-account.  It is only created if the
                                            `use_system_restore` variable is set to true.
   * `role` - The role that will be assumed by the `system-restore-terraform-permissions` user to deploy resources to 
              deploy `system-restore` AWS sub-account.  This value defaults to an empty string.
   * `AWS_ACCESS_KEY_ID` - The ID of the AWS access key the the `system-restore-terraform-permissions` user will use to
                           manage resources in the `system-restore` AWS sub-account.  This value defaults to an empty
                           string.
   * `AWS_SECRET_ACCESS_KEY` - The AWS secret access key  that the `system-restore-terraform-permissions` user will use
                               to manage resources in the `system-restore` AWS sub-account.  This value defaults to an
                               empty string.

The following run triggers are also managed:

  * `terraform-permissions` will be automatically planned after the following workspaces are successfully deployed:
    * `terraform-cloud`
  * `root` will be automatically planned after the following workspaces are successfully deployed:
    * `terraform-cloud`
    * `terraform-permissions`
  * If the `use_system_restore` variable is set to true, `system-restore` will be automatically planned after the
    following workspaces are successfully deployed:
    * `terraform-cloud`
    * `root`
    * `system-restore-terraform-permissions`
  * If the `use_system_restore` variable is set to true, `system-restore-terraform-permissions` will be automatically
    planned after the following workspaces are successfully deployed:
    * `terraform-cloud`
    * `root`        

### terraform-permissions

The terraform in the `terraform-permissions` directory manages the resources used by the `terraform` IAM user.  The
following resources are managed:

 * IAM Users
    * `terraform` - The user that will deploy resources to the root AWS account.
 * IAM Policies
    * `terraform-manage-users` - Allow all users except the `terraform` user to be managed.
    * `terraform-manage-policies` - Allow management of all IAM policies that are not managed by this terraform.
    * `terraform-manage-sns` - Allow the `notify-me` SNS topic to be managed.
    * `terraform-manage-cloudwatch` - Allow the `billing-alarm` cloudwatch alarm to be managed.
    * `terraform-manage-organizations` - Allow AWS organizations to be managed.  Do not allow accounts to be deleted.
    * `terraform-manage-account` - Allow the AWS account alias to be managed.
 * IAM Policy Attachments - All policies managed by this terraform are attached to the `terraform` IAM user.

### root

The terraform in the `root` directory manages all resources in the AWS root account not associated with the `terraform`
user.  It manages the following:

 * IAM Users
    * `admin` - An IAM user with full control over the account.
    * `terraform-permissions` - An IAM user for managing the `terraform` user and its policies.
    * `system-restore-terraform` - An IAM user that will be used to deploy resources to the `system-restore` AWS
                                   sub-account.  This user is only created when the `use-system-restore` variable is
                                   set to true.
    * `system-restore-terraform-permissions` - An IAM user that will be used to manage the permissions of the
                                               `terraform` IAM role in the `system-restore` AWS sub-account.  This user
                                               is only created when the `use-system-restore` variable is set to true.
 * IAM Policies
    * `administer-system-restore` - Allow the `OrganizationAccountAccessRole` IAM role to be assumed in the
                                    `system-restore` AWS sub-account.  This policy is only created when the
                                    `use_system_restore` variable is set to true.
    * `deploy-system-restore` - Allow the `terraform` IAM role to be assumed in the `system-restore` AWS sub-account.
                                This policy is only created when the `use_system_restore` variable is set to true.
    * `deploy-system-restore-deploy-permissions` - Allow the `terraform-permissions` IAM role to be assumed in the
                                                   `system-restore` AWS sub-account.  This policy is only created when
                                                   the `use_system_restore` variable is set to true.
    * `manage-terraform-user` - Allow the `terraform` user to be managed.
    * `terraform-permissions-manage-policies` - Allow all policies except those attached to the `terraform-policies`
                                                IAM User to be managed.
 * IAM Policy Attachments
    * The following policies are attached to the `admin` user:
        * `AdministratorAccess`
        * `administer-system-restore` - This policy is only attached when the `user_system_restore` variable is set to
                                        true.
    * The following policies are attached to the `terraform-permissions` user:
        * `manage-terraform-user`
        * `terraform-permissions-manage-policies`
    * The following policies are attached to the `system-restore-terraform` user when the `use_system_restore` variable
      is set to true:
        * `deploy-system-restore`
    * The following policies are attached to the `system-restore-terraform-permissions` user when the
      `use_system_restore` variable is set to true:
        * `deploy-system-restore-deploy-permissions`
 * AWS Organizations - An organization is created within your root account with service control policies enabled.
 * AWS Sub-Accounts
   * `system-restore` - An account in which the `system-restore` project can be run.  This account will inherit the
                        default service control policy from the root AWS account, which should be manually disabled for
                        optimal security.  This sub-account is only created if the `use_system_restore` variable is set
                        to true.  
 * Service Control Policies
    * `manage-iam` - Allows IAM users, groups, policies and roles and account aliases to be managed in a sub-account.
                     It also allows the organization to be described.
    * `system-restore` - Allows the reading and writing of encrypted and unencrypted parameters from the SSM parameter
                         store.  This service control policy is only created if the `use_system_restore` variable is set
                         to true.
 * Organization Policy Attachments
    * The following service control policies are attached to the `system-restore` account if the `use_system_restore`
      variable is set to true.
        * `manage-iam`
        * `system-restore`
 * SNS Topics
   * `notify-me` - A topic that will be used to send you notifications about your account.  You must manually create a
                   subscription to the topic.
 * Cloudwatch Alarms
   * `billing-alarm` - An alarm that will be triggered when the estimated AWS charges for the month exceed the
                       configured limit.  The `notify-me` SNS topic will be notified when this alarm is triggered.

# Initial Setup

 1. Create an AWS account ([instructions](https://tinyurl.com/y7aq2ky5)).
 1. Create AWS root access keys
    1. Navigate [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials).
    1. Expand `Access keys`.
    1. Click `Create New Access Key`.
    1. Click `Show Access Key` and take note of the new access key ID and secret access key.
 1. Click `Receive Billing Alerts` [here](https://console.aws.amazon.com/billing/home?#/preferences).
 1. Fork this repository for use with Terraform Cloud.   
 1. Setup Terraform Cloud account ([instructions](https://tinyurl.com/y8ph3b5r)).
    1. Create a new account.
    1. Create a new organization.
    1. Configure GitHub OAuth Access using these [instructions](https://www.terraform.io/docs/cloud/vcs/github.html).
        1. Note the OAuth Token ID on the final page.
    1. Create a new API Token
        1. Click on your avatar and click `User Settings`.
        1. Click `Tokens`.
        1. Click `Create an API token`.
        1. Give the token a description and click `Create API Token`.
        1. Make note of your token and click `Done`.
    1. Create a workspace.
        1. Give the organization access to your fork of this repository.
        1. Name the workspace `terraform-cloud`.
        1. Under `Advanced options`, set `Terraform Working Directory` to `terraform-cloud`.
        1. Configure Variables
            1. Terraform Variables
                1. `account_alias` - An alias for your AWS account ID.  It must start with an alphanumeric character and
                                     only contain lowercase alphanumeric characters and hyphens.            
                1. `terraform_cloud_organization` - The name of your Terraform Cloud organization.
                1. `github_user` - The name of your github account that contains forks of the repositories being used.
                1. `github_token` - The OAuth token created to give Terraform Cloud access to github.
            1. Environment Variables
                1. `TFE_TOKEN` - The API token created earlier that will allow this workspace to manage terraform cloud
                                 resources.  This variable should be marked `sensitive`.
 1. Apply the terraform to setup your Terraform Cloud workspaces.
    1. In Terraform Cloud, click the `Queue plan` button.
    1. When the plan completes, click the `Confirm & Apply` button.
 1. Deploy the `terraform-permissions` workspace
    1. From the workspaces page in terraform cloud, select `terraform-permissions`.
    1. Click `Variables`
    1. Configure variables
        1. Environment Variables
            1. `AWS_ACCESS_KEY_ID` - The ID of the root AWS access key created earlier.
            1. `AWS_SECRET_ACCESS_KEY` - The root AWS secret access key created earlier.
    1. Click the `Queue plan button`.
    1. When the plan completes, click the `Confirm & Apply` button.
 1. Delete your root access keys.
    1. Navigate [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials).
    1. Expand `Access keys`.
    1. Click `Delete` next to your access key.
    1. Confirm by clicking `Yes`.
 1. Create AWS access keys for the `terraform` user
    1. Navigate
       [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/users/terraform?section=security_credentials).
    1. Expand `Access keys`.
    1. Click `Create New Access Key`.
    1. Click `Show Access Key` and take note of the new access key ID and secret access key.
 1. Deploy the `root` workspace
    1. From the workspaces page in terraform cloud, select `root`.
    1. Click `Variables`
    1. Configure variables
        1. `charge_warning_dollars` - The number of US dollars spent in the AWS account in a month that will trigger a
                                      warning notification to be sent. AWS will evaluate the estimated charges every 6
                                      hours.
        1. Environment Variables
            1. `AWS_ACCESS_KEY_ID` - The ID of the `terraform` user's AWS access key created earlier.
            1. `AWS_SECRET_ACCESS_KEY` - The AWS secret access key of the `terraform` user.
    1. Click the `Queue plan button`.
    1. When the plan completes, click the `Confirm & Apply` button.
 1. Approve the AWS Organizations email verification request that AWS sends you.
 1. Subscribe to AWS billing alert alarms.
    1. Navigate [here](https://console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics)
    1. Click `notify-me`.
    1. Click `Create subscription`.
    1. Subscribe.
        1. Set Protocol to `Email`
        1. Set Endpoint to your e-mail address.
        1. Click `Create subscription`.
        1. Confirm the subscription e-mail that arrives in your inbox.
 1. Create Sign-in credentials for the AWS `admin` user.
    1. Navigate
       [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/users/admin?section=security_credentials).
    1. Under `Security credentials`, click `Manage` beside `Console password`.
        1. Select `Enable`.
        1. Select `Custom Password`.
        1. Fill in a password.
        1. Click `Apply`.
    1. Optionally (but recommended), set up MFA by clicking `Manage` beside `Assigned MFA device`.
        1. Follow on screen instructions based on your choice of MFA device.
 1. Create access keys for the AWS `terraform-permissions` user.
    1. Navigate[here](https://console.aws.amazon.com/iam/home?region=us-east-1#/users/terraform-permissions?section=security_credentials).
    1. Click `Create access key`.
    1. Make note of the `Access key ID` and `Secret access key`.
 1. Update the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables in your Terraform Cloud 
    `terraform-permissions` workspace to be the key's created for the `terraform-permissions` user.

# Keeping Account Up To Date

Every time changes are delivered to the main branch of your fork, Terraform Cloud will automatically run a plan.  You
must log in to Terraform Cloud and Confirm and Apply the changes.  You may also choose to automatically apply successful
plans.

Because changes in one workspace may be required before another workspace functions properly, it is likely that you will
see plans fail.  This is ok.  After you successfully deploy the workspaces that were successfully planned, any
workspaces that depend on that repository will be automatically re-planned.  Because Terraform Cloud run triggers cannot
create a loop, the following dependencies cannot be triggered automatically and must be manually planned:

 * `terraform-permissions` after a change to `root`
 * `system-restore-terraform-permissions` after a change to `system-restore` 

# Destroying Resources

It should be possible to destroy the `terraform-cloud` workspace at any time.

The `root` workspace can be destroyed as long as the `terraform-permissions` workspace is deployed.  Destroying this
workspace will require you to switch the `terraform-permissions` repository to use root access keys to do anything.
Deleting a sub-account from an organization won't actually delete the sub-account.  For this reason, the `terraform`
user does not have permission to delete any sub-accounts that it has created.  If you want to do this, you will need to
update the AWS access keys in the `root` workspace to be root access keys.  Make sure you understand how to manage or
close any sub-accounts before running `terraform-destory`.

The `terraform-permissions` workspace can be destroyed as long as the `root` workspace is deployed.  Destroying it will
require switching the `root` workspace to use root access keys to do anything.

The `system-restore` workspace can be destroyed as long as the `root` workspace is deployed.

If you want to destroy a workspace that depends upon a workspace that has already been destroyed, you can switch the
AWS access keys of the workspace to destroy to root access keys.

Before using root access keys, make sure you understand the security risks.