---
description: StackState Self-hosted v5.0.x
---

# StackState/Agent IAM role for EC2

## Overview

If StackState and/or StackState Agent are running within an AWS environment on an EC2 instance, an IAM role can be attached to the EC2 instance for authentication. When this role is available:

* For StackState authentication (CloudWatch metrics): The AWS StackPack can be installed with the `use-role` option for the **AWS Access Key ID** and **AWS Secret Access Key**). The attached role will be used by StackState for authentication.
* For StackState Agent authentication (topology, logs and VPC flow logs): The Agent AWS check can be configured with empty quotes for the parameters `aws_access_key_id` and `aws_secret_access_key`. The attached role will be used by StackState Agent for authentication.

{% hint style="info" %}
Note: If the AWS Data Collection Account and the Monitor Account are not inside the same AWS organization, it is not possible to authenticate using an IAM role in this way. For details see the AWS documentation on [AWS organizations \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html).  
{% endhint %}

## Set up IAM role for StackState/StackState Agent on EC2

To set up an IAM role for StackState or StackState Agent to use, follow the instructions below.

1. If you did not do so already, [create a policy](/stackpacks/integrations/aws/aws.md#aws-policy) that allows the `AssumeRole` action for the resource `arn:aws:iam::*:role/StackStateAwsIntegrationRole`. Take note of the policy name.
2. Create an EC2 instance role and attach the policy from the previous step. 
   ![Policy for AssumeRole](/.gitbook/assets/sts_on_ec2_aws_stp_02.png)
3. Attach the newly created EC2 instance role to the EC2 instance where StackState or the StackState Agent is running.
   ![Attach role to EC2 instance](/.gitbook/assets/sts_on_ec2_aws_stp_03.png)
4. Configure the StackPack instance or Agent AWS check to [authenticate using the attached IAM role](/stackpacks/integrations/aws/aws.md#iam-role-on-ec2-or-eks).

## See also

* [AWS StackPack](/stackpacks/integrations/aws/aws.md)
