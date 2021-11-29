---
description: AWS EC2 role setup for the StackState AWS integration
---

# AWS EC2 role setup for AWS StackPack use-role option

If StackState is running within an AWS environment on an EC2 instance it can have an IAM role with attached to the EC2 instance that enables AWS StackPack to be installed with `use-role` option.

## Error when IAM policy is not attached 

If the IAM policy is not attached to EC2 instance role the following error happens during AWS StackPack installation with `use-role` option.

![Failed AWS installation](../../.././.gitbook/assets/sts_on_ec2_aws_stp_01.png)

To fix this we need to attach the appropriate role to EC2 instance. Take note of the node group role name. The AWS StackPack instance is in Error State. Press the `UNINSTALL` button to remove it.

## Create EC2 instance role

1. Create a policy that allows `AssumeRole` action for `arn:aws:iam::*:role/StackStateAwsIntegrationRole` resource. Take note of the policy name.
2. Create a EC2 instance role and attach policy from the previous step.

![Policy for assume role](../../.././.gitbook/assets/sts_on_ec2_aws_stp_02.png)

This policy is one of the prerequisites for [AWS Integration Setup](https://docs.stackstate.com/stackpacks/integrations/aws/aws#prerequisites). 


## Attach role to EC2 instance

Attach the role to the EC2 instance.

![03](../../.././.gitbook/assets/sts_on_ec2_aws_stp_03.png)

## Repeat the AWS StackPack installation

Installation of AWS StackPack using `use-role` option now finishes successfully.

![04](../../.././.gitbook/assets/sts_on_ec2_aws_stp_04.png)


