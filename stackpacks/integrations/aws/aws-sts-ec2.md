---
description: AWS EC2 role setup for the StackState AWS integration
---

# IAM role for EC2

## Overview

If StackState is running within an AWS environment on an EC2 instance, it can have an IAM role attached to the EC2 instance. When this role is available, the AWS StackPack can be installed with the `use-role` option for IAM authentication (the **AWS Access Key ID** and **AWS Secret Access Key**). StackState Agent will then authenticate using the attached role. 

## Set up IAM role for EC2

1. Create a policy that allows the `AssumeRole` action for the resource `arn:aws:iam::*:role/StackStateAwsIntegrationRole`.
   * Take note of the policy name.
   * This policy is one of the prerequisites for [AWS Integration Setup](/stackpacks/integrations/aws/aws.md#prerequisites).
2. Create an EC2 instance role and attach the policy from the previous step. 
   ![Policy for assume role](/.gitbook/assets/sts_on_ec2_aws_stp_02.png)
3. Attach the role to the EC2 instance.
   ![Attach ](/.gitbook/assets/sts_on_ec2_aws_stp_03.png)

## Error when IAM policy is not attached 

If the IAM policy is not attached to the EC2 instance role, the following error happens during AWS StackPack installation with `use-role` option.

![Failed AWS installation](/.gitbook/assets/sts_on_ec2_aws_stp_01.png)

To fix this, the correct role needs to be attached to the EC2 instance where StackState is running:

1. The AWS StackPack instance is in Error State, press the `UNINSTALL` button to remove it.
2. [Set up the IAM role](#set-up-iam-role-for-ec2).
3. Install a new instance of the StackPack using the `use-role` option.

![Successful install with `use-role`](../../.././.gitbook/assets/sts_on_ec2_aws_stp_04.png)


