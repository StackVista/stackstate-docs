---
description: Rancher Observability Self-hosted v5.1.x 
---

# Rancher Observability/Agent IAM role for EKS

## Overview

If Rancher Observability or Rancher Observability Agent V2 are running within an AWS environment in an EKS cluster instance, an IAM role can be attached to the node-group where the pods `stackstate-api` or `stackstate-cluster-agent` are running. 

* `stackstate-api` pod - the attached role can be used for authentication by Rancher Observability running in these pods.
* `stackstate-cluster-agent` pod - the attached role can be used for authentication by Rancher Observability Cluster Agent running in this pod.

{% hint style="info" %}
Note: If the AWS Data Collection Account and the Monitor Account aren't a part of the same AWS organization, it isn't possible to authenticate using the attached IAM role in this way. For details see the AWS documentation on [AWS organizations \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html). 
{% endhint %}

## Set up IAM role for Rancher Observability/Rancher Observability Agent on EKS

To set up an IAM role for Rancher Observability or Rancher Observability Agent to use, follow the instructions below.

1. If you did not do so already, [create a policy](/stackpacks/integrations/aws/aws.md#aws-policy) that allows the `AssumeRole` action for the resource `arn:aws:iam::*:role/Rancher ObservabilityAwsIntegrationRole`. Take note of the policy name.
2. Find the node-group that contains nodes running the relevant pod or pods and create a node group role:
   * **Rancher Observability on EKS**: `stackstate-api`.
   * **Rancher Observability Agent on EKS**: `stackstate-cluster-agent`.
3. Attach the policy from the first step to the node-group role from the previous step.

   ![Policy for node group role](/.gitbook/assets/sts_on_eks_aws_stp_03.png)

4. Configure the StackPack instance or Agent AWS check to [authenticate using the attached IAM role](/stackpacks/integrations/aws/aws.md#iam-role-on-ec2-or-eks).

## See also

* [AWS StackPack](/stackpacks/integrations/aws/aws.md)
