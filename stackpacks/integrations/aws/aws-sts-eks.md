---
description: StackState Self-hosted v5.0.x
---

# StackState/Agent IAM role for EKS

## Overview

If StackState or the StackState Agent are running within an AWS environment in an EKS cluster instance, an IAM role can be attached to the node-group where the pods `stackstate-api`, `stackstate-server` and/or `stackstate-cluster-agent` are running. 

* When this role is available on the `stackstate-api` and `stackstate-server` pods, the AWS StackPack can be installed with the `use-role` option for IAM authentication (the **AWS Access Key ID** and **AWS Secret Access Key**). The attached role will then be used by the StackState CloudWatch plugin to retrieve metrics from CloudWatch.
* When this role is available on the `stackstate-cluster-agent` pod and the AWS check is configured to [run as a cluster check](/stackpacks/integrations/aws.md#configure-aws-check-as-a-cluster-check), the AWS check can be configured  with empty quotes for the parameters `aws_access_key_id` and `aws_secret_access_key` in the `values.yaml` file used to deploy the Cluster Agent. The attached role will be used by StackState Agent for authentication.

{% hint style="info" %}
Note: If the AWS Data Collection Account and the Monitor Account are not inside the same AWS organization, it is not possible to authenticate using an IAM role in this way. For details see the AWS documentation on [AWS organizations \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html).  
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
