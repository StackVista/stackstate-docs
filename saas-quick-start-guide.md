---
description: StackState SaaS
---

# StackState quick start guide

## Overview

When your StackState SaaS instance has been set up and configured, you will receive an email from StackState with the required login details. This quick start guide will help you get started and get your own data into your StackState SaaS instance.

* [Integrate with AWS](#aws-quick-start-guide)
* [Integrate with Kubernetes](#kubernetes-quick-start-guide)
* [Integrate with OpenShift](#openshift-quick-start-guide)

## AWS quick start guide

Set up an AWS integration to collect topology, events and metrics data from your AWS environment and make this available in StackState.

### Prerequisites for AWS

To set up a StackState AWS integration you need to have:

* At least one target AWS account that will be monitored.
* An AWS account for StackState Agent V2 to use when retrieving data from the target AWS accounts. It's recommended to use a separate shared account for this and not use any of the accounts that will be monitored by StackState, but this isn't required.
    * If StackState Agent will run within an AWS environment: The EC2 instance can have an IAM role attached to it. The Agent will then use this role by default.
    * The IAM role must have the following IAM policy. This policy grants the IAM principal permission to assume the role created in each target AWS account.
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::*:role/StackStateAwsIntegrationRole"
    }
  ]
}
```

### Set up an AWS integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for AWS](#prerequisites-for-aws).
{% endhint %}

To get data from an AWS environment into StackState, follow the steps described below:

1. [Deploy the AWS CloudFormation Stack](stackpacks/integrations/aws/aws.md#deploy-the-aws-cloudformation-stack) in the AWS  account that will be monitored.
2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to **StackPacks** > **Integrations** > **AWS**.
3. Install a new instance of the AWS StackPack:
   * Specify:
     * **Role ARN** - the ARN of the IAM Role created by the cloudFormation stack. For example, `arn:aws:iam::<account id>:role/StackStateAwsIntegrationRole` where `<account id>` is the 12-digit AWS account ID that is being monitored. 
     * **External ID** - a shared secret that StackState will present when assuming a role. Use the same value across all AWS accounts. For example, `uniquesecret!1`
     * **AWS Access Key ID** - The Access Key ID of the IAM user used by StackState Agent V2. If the StackState instance is running within AWS, enter the value `use-role` and the instance will authenticate using the attached IAM role. 
     * **AWS Secret Access Key** - The Secret Access Key of the IAM user used by StackState Agent V2. If the StackState instance is running within AWS, enter the value `use-role` and the instance will authenticate using the attached IAM role.
   * Click **INSTALL**.
4. [Install StackState Agent V2](/setup/agent/about-stackstate-agent.md#deployment) on a machine which can connect to both AWS and StackState.
5. [Configure the AWS check](/stackpacks/integrations/aws/aws.md#configure-the-aws-check) on StackState Agent V2.
   * Once the check has been configured and the Agent restarted, wait for data to be collected from AWS and sent to StackState.

➡️ [Learn more about the StackState AWS integration](/stackpacks/integrations/aws/aws.md)

## Kubernetes quick start guide

Set up a Kubernetes integration to collect topology, events and metrics data from a Kubernetes cluster and make this available in StackState.

### Prerequisites for Kubernetes

To set up a StackState Kubernetes integration you need to have:

* An up and running Kubernetes Cluster.
* A recent version of Helm 3.
* A user with permissions to create privileged pods, ClusterRoles and ClusterRoleBindings:
  * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the Kubernetes API.
  * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up a Kubernetes integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for Kubernetes](#prerequisites-for-kubernetes).
{% endhint %}

To get data from a Kubernetes cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```
   
2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to **StackPacks** > **Integrations** > **Kubernetes**.
3. Install a new instance of the Kubernetes StackPack:
   * Specify a **Kubernetes Cluster Name** - this name will be used to identify the cluster in StackState.
   * Click **INSTALL**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your Kubernetes cluster using the helm command provided in the StackState UI after you have installed the StackPack.
   * Once the Agents have been deployed, they will begin collecting data and push this to StackState

➡️ [Learn more about the StackState Kubernetes integration](/stackpacks/integrations/kubernetes.md)

## OpenShift quick start guide

Set up an OpenShift integration to collect topology, events and metrics data from an OpenShift cluster and make this available in StackState.

### Prerequisites for OpenShift

To set up a StackState OpenShift integration you need to have:

* An up and running OpenShift Cluster.
* A recent version of Helm 3.
* A user with permissions to create privileged pods, ClusterRoles, ClusterRoleBindings and SCCs:
  * ClusterRole and ClusterRoleBinding are needed to grant StackState Agents permissions to access the OpenShift API.
  * StackState Agents need to run in a privileged pod to be able to gather information on network connections and host information.

### Set up an OpenShift integration

{% hint style="warning" %}
Before you begin, check the [prerequisites for OpenShift](#prerequisites-for-openshift).
{% endhint %}

To get data from an OpenShift cluster into StackState, follow the steps described below:

1. Add the StackState helm repository to the local helm client:
    ```buildoutcfg
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
    ```
   
2. In the StackState UI, open the main menu by clicking in the top left of the screen and go to **StackPacks** > **Integrations** > **OpenShift**.
3. Install a new instance of the Kubernetes StackPack:
   * Specify a **OpenShift Cluster Name** - this name will be used to identify the cluster in StackState.
   * Click **INSTALL**.
4. Deploy the StackState Agent, Cluster Agent, Checks Agent and kube-state-metrics on your OpenShift cluster using the helm command provided in the StackState UI after you have installed the StackPack.
   * Once the Agents have been deployed, they will begin collecting data and push this to StackState

➡️ [Learn more about the StackState OpenShift integration](/stackpacks/integrations/openshift.md)

## What next?

- [StackState walk-through](/getting_started.md)
- [All available integrations](/stackpacks/integrations/)
- [All available add-ons](/stackpacks/add-ons/)