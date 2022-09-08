---
description: StackState Self-hosted v4.5.x
---

# StackState IAM role for EKS

{% hint style="warning" %}
This page describes StackState v4.5.x.
The StackState 4.5 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.5 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/aws/aws-sts-eks).
{% endhint %}

## Overview

If StackState is running within an AWS environment in an EKS cluster instance, it can have an IAM role attached to the node-group where the pods `stackstate-api` and `stackstate-server` are running. When this role is available, the AWS StackPack can be installed with the `use-role` option for IAM authentication (the **AWS Access Key ID** and **AWS Secret Access Key**). The attached role will then be used by the StackState CloudWatch plugin to retrieve metrics from CloudWatch.

## Set up IAM role for StackState on EKS

To set up an IAM role for the AWS StackPack to use, follow the instructions below.

1. Create a policy that allows the `AssumeRole` action for the resource `arn:aws:iam::*:role/StackStateAwsIntegrationRole`. This is the same policy as used for the [Agent IAM role on EC2](aws.md#iam-role-for-agent-on-ec2). Take note of the policy name.
2. Find the node-group that contains nodes running the pods `stackstate-api` and `stackstate-server` and create a node group role.
3. Attach the policy from the first step to the node-group role from the previous step.

![Policy for node group role](/.gitbook/assets/sts_on_eks_aws_stp_03.png)

## See also

* [AWS StackPack](/stackpacks/integrations/aws/aws.md)
* [Agent IAM role on EC2](aws.md#iam-role-for-agent-on-ec2)
* [StackState IAM role for EC2](/stackpacks/integrations/aws/aws-sts-ec2.md)
