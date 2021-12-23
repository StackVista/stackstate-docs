

# StackState IAM role for EC2

## Overview

If StackState is running within an AWS environment on an EC2 instance, it can have an IAM role attached to the EC2 instance. When this role is available, the AWS StackPack can be installed with the `use-role` option for IAM authentication (the **AWS Access Key ID** and **AWS Secret Access Key**). The attached role will then be used by the StackState CloudWatch plugin to retrieve metrics from CloudWatch.

## Set up IAM role for StackState on EC2

To set up an IAM role for the AWS StackPack to use, follow the instructions below.

1. Create a policy that allows the `AssumeRole` action for the resource `arn:aws:iam::*:role/StackStateAwsIntegrationRole`. This is the same policy as used for the [Agent IAM role on EC2](aws.md#iam-role-for-agent-on-ec2). Take note of the policy name.
2. Create an EC2 instance role and attach the policy from the previous step. 
   ![Policy for AssumeRole](/.gitbook/assets/sts_on_ec2_aws_stp_02.png)
3. Attach the newly created EC2 instance role to the EC2 instance where StackState is running.

![Attach role to EC2 instance](/.gitbook/assets/sts_on_ec2_aws_stp_03.png)

## See also

* [AWS StackPack](/stackpacks/integrations/aws/aws.md)
* [Agent IAM role on EC2](aws.md#iam-role-for-agent-on-ec2)
* [StackState IAM role for EKS](/stackpacks/integrations/aws/aws-sts-eks.md)
