---
description: AWS EKS role setup for the StackState AWS integration
---

# AWS EKS policy setup for AWS StackPack use-role option

If StackState is running within an AWS environment on an EKS cluster it can have an IAM role with attached to its node group that enables AWS StackPack to be installed with `use-role` option.

In the following example uses AWS EKS cluster with Amazon EC2 Linux managed nodes. 

## Error when IAM policy is not attached 

If the IAM policy is not attached to node group role the following error happens during AWS StackPack installation with `use-role` option.

![Failed AWS installation](../../.././.gitbook/assets/sts_on_eks_aws_stp_01.png)

To fix this we need to attach the appropriate policy to node group role. Take note of the node group role name. The AWS StackPack instance is in Error State. Press the `UNINSTALL` button to remove it.

## Find the missing policy

Find the policy that allows `AssumeRole` action for `arn:aws:iam::*:role/StackStateAwsIntegrationRole` resource.

![Policy for assume role](../../.././.gitbook/assets/sts_on_eks_aws_stp_02.png)

This policy is one of the prerequisites for [AWS Integration Setup](https://docs.stackstate.com/stackpacks/integrations/aws/aws#prerequisites). 

Take note of the policy name.

## Attach policy to node-group role

Find the node group role and attach the policy to it.

![03](../../.././.gitbook/assets/sts_on_eks_aws_stp_03.png)

## Repeat the AWS StackPack installation

Installation of AWS StackPack using `use-role` option now finishes successfully.

![04](../../.././.gitbook/assets/sts_on_eks_aws_stp_04.png)


