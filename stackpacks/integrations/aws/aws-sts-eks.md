---
description: StackState Self-hosted v4.6.x
---

# StackState/Agent IAM role for EKS

## Overview

If StackState or the StackState Agent are running within an AWS environment in an EKS cluster instance, an IAM role can be attached to the node-group where the pods `stackstate-api`, `stackstate-server` and/or `stackstate-cluster-agent` are running. 

* When this role is available on the `stackstate-api` and `stackstate-server` pods, the AWS StackPack can be installed with the `use-role` option for IAM authentication (the **AWS Access Key ID** and **AWS Secret Access Key**). The attached role will then be used by the StackState CloudWatch plugin to retrieve metrics from CloudWatch.
* When this role is available on the `stackstate-cluster-agent` pod and the AWS check is configured to [run as a cluster check](/stackpacks/integrations/aws.md#configure-aws-check-as-a-cluster-check), the AWS check can be configured with the `use-role` option for IAM authentication. 

## Set up IAM role for StackState on EKS

To set up an IAM role for the AWS StackPack to use, follow the instructions below.

1. Create a policy that allows the `AssumeRole` action for the resource `arn:aws:iam::*:role/StackStateAwsIntegrationRole`. This is the same policy as used for the [Agent IAM role on EC2](aws.md#iam-role-for-agent-on-ec2). Take note of the policy name.
2. Find the node-group that contains nodes running the relevant pod or pods and create a node group role:
   * For StackState on EKS: `stackstate-api` and `stackstate-server`.
   * For StackState Agent on EKS: `stackstate-cluster-agent`.
3. Attach the policy from the first step to the node-group role from the previous step.

![Policy for node group role](/.gitbook/assets/sts_on_eks_aws_stp_03.png)

## See also

* [AWS StackPack](/stackpacks/integrations/aws/aws.md)
* [Agent IAM role on EC2](aws.md#iam-role-for-agent-on-ec2)
* [StackState IAM role for EC2](/stackpacks/integrations/aws/aws-sts-ec2.md)
