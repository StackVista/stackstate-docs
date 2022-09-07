---
description: StackState Self-hosted v5.0.x 
---

# StackState/Agent IAM role for EKS

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/aws/aws-sts-eks).
{% endhint %}

## Overview

If StackState or the StackState Agent are running within an AWS environment in an EKS cluster instance, an IAM role can be attached to the node-group where the pods `stackstate-api`, `stackstate-server` and/or `stackstate-cluster-agent` are running. 

* `stackstate-api` and `stackstate-server` pods - the attached role can be used for authentication by StackState running in these pods.
* `stackstate-cluster-agent` pod - the attached role can be used for authentication by StackState Cluster Agent running in this pod.

{% hint style="info" %}
Note: If the AWS Data Collection Account and the Monitor Account are not a part of the same AWS organization, it is not possible to authenticate using the attached IAM role in this way. For details see the AWS documentation on [AWS organizations \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html).  
{% endhint %}

## Set up IAM role for StackState/StackState Agent on EKS

To set up an IAM role for StackState or StackState Agent to use, follow the instructions below.

1. If you did not do so already, [create a policy](/stackpacks/integrations/aws/aws.md#aws-policy) that allows the `AssumeRole` action for the resource `arn:aws:iam::*:role/StackStateAwsIntegrationRole`. Take note of the policy name.
2. Find the node-group that contains nodes running the relevant pod or pods and create a node group role:
   * **StackState on EKS**: `stackstate-api` and `stackstate-server`.
   * **StackState Agent on EKS**: `stackstate-cluster-agent`.
3. Attach the policy from the first step to the node-group role from the previous step.

   ![Policy for node group role](/.gitbook/assets/sts_on_eks_aws_stp_03.png)

4. Configure the StackPack instance or Agent AWS check to [authenticate using the attached IAM role](/stackpacks/integrations/aws/aws.md#iam-role-on-ec2-or-eks).

## See also

* [AWS StackPack](/stackpacks/integrations/aws/aws.md)
