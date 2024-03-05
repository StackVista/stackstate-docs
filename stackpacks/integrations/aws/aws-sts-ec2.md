---
description: StackState SaaS
---

# StackState/Agent IAM role for EC2

## Overview

If StackState or StackState Agent are running within an AWS environment on an EC2 instance, an IAM role can be attached to the EC2 instance for authentication. When this role is available it can be used for authentication by StackState or StackState Agent running on the same EC2 instance.

{% hint style="info" %}
Note: If the AWS Data Collection Account and the Monitor Account aren't a part of the same AWS organization, it isn't possible to authenticate using the attached IAM role in this way. For details see the AWS documentation on [AWS organizations \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html). 
{% endhint %}

## Set up IAM role for StackState/StackState Agent on EC2

To set up an IAM role for StackState or StackState Agent to use, follow the instructions below.

1. If you did not do so already, [create a policy](/stackpacks/integrations/aws/aws.md#aws-policy) that allows the `AssumeRole` action for the resource `arn:aws:iam::*:role/StackStateAwsIntegrationRole`. Take note of the policy name.
2. Create an EC2 instance role and attach the policy from the previous step. 

   ![Policy for AssumeRole](/.gitbook/assets/sts_on_ec2_aws_stp_02.png)

3. Attach the newly created EC2 instance role to the EC2 instance where StackState or StackState Agent V2 is running.

   ![Attach role to EC2 instance](/.gitbook/assets/sts_on_ec2_aws_stp_03.png)

4. Configure the StackPack instance or Agent AWS check to [authenticate using the attached IAM role](/stackpacks/integrations/aws/aws.md#iam-role-on-ec2-or-eks).

## See also

* [AWS StackPack](/stackpacks/integrations/aws/aws.md)
