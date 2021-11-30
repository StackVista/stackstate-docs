---
description: AWS EKS role setup for the StackState AWS integration
---

# StackState IAM role for EKS

## Overview

## Set up IAM role for StackState on EKS

To set up an IAM role for the AWS StackPack to use, follow the instructions below.

1. Create a policy that allows the `AssumeRole` action for the resource `arn:aws:iam::*:role/StackStateAwsIntegrationRole`. This is the same policy as used for the [Agent IAM role on EC2](aws.md#iam-role-for-agent-on-ec2). Take note of the policy name.
2. Find the node-group that contains nodes running the pods `stackstate-api` and `stackstate-server` and create a node group role.
3. Attach the policy from the first step to the node-group role from the previous step.

![Policy for node group role](/.gitbook/assets/sts_on_eks_aws_stp_03.png)

## Error: (Access denied) when calling the AssumeRole operation

If the correct IAM policy is not attached to the EKS cluster role, an error will be returned when attempting to install the AWS StackPack with the `use-role` option.

![Failed AWS installation](/.gitbook/assets/sts_on_eks_aws_stp_01.png)

To resolve this:

1. Take note of the node group role name in the error message.
2. Click **UNINSTALL** to uninstall the StackPack reporting the error.
3. [Set up the IAM role for StackState](#set-up-iam-role-for-stackstate-on-eks). Note that the policy should be attached to the node-group role name reported in the error message - it is not necessary to create a new node-group role.
4. Install the AWS StackPack again.

## See also

* [AWS StackPack](/stackpacks/integrations/aws/aws.md)
* [Agent IAM role on EC2](aws.md#iam-role-for-agent-on-ec2)
* [StackState IAM role for EC2](/stackpacks/integrations/aws/aws-sts-ec2.md)
