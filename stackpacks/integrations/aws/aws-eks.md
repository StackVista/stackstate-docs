---
description: StackState Self-hosted v5.0.x
---

# AWS EKS

## Overview

Amazon Web Services \(AWS\) is a major cloud provider. This StackPack enables in-depth monitoring of AWS services. 

![Data flow](../../../.gitbook/assets/stackpack-aws-v2.svg)

* StackState Agent V2 collects all service responses from the target AWS account.
* Topology is updated in real time:
  * Once an hour, all services are queried to gain a full point-in-time snapshot of resources.
  * Once a minute, Cloudtrail and Eventbridge events are read to find changes to resources.
* Logs are retrieved once a minute from CloudWatch and a central S3 bucket. These are mapped to associated components in StackState.
* Metrics are retrieved on-demand by the StackState CloudWatch plugin. These are mapped to associated components in StackState.
* [VPC FlowLogs](#configure-vpc-flowlogs) are retrieved once a minute from the configured S3 bucket. Private network traffic inside VPCs is analysed to create relations between EC2 and RDS database components in StackState.
* Communication between NodeJS Lambda functions and the AWS services that they communicate with is monitored using [OpenTelemetry traces](#traces).

AWS is a [StackState core integration](/stackpacks/integrations/about_integrations.md#stackstate-core-integrations "StackState Self-Hosted only").

## Setup

### StackState Receiver API address

StackState Agent connects to the StackState Receiver API at the specified [StackState Receiver API address](/setup/agent/about-stackstate-agent.md#stackstate-receiver-api-address). The correct address to use is specific to your installation of StackState.

### Install

The StackState Agent, Cluster Agent and kube-state-metrics can be installed together using the Cluster Agent Helm Chart:

1. If you do not already have it, you will need to add the StackState helm repository to the local helm client:

   ```text
    helm repo add stackstate https://helm.stackstate.io
    helm repo update
   ```

2. Deploy the StackState Agent, Cluster Agent and kube-state-metrics using the [configuration yaml file (values.yaml)](#configure-the-aws-cluster-check) with the following helm command:

    ```text
        helm upgrade --install \
        --namespace stackstate \
        --create-namespace \
        --set-string 'stackstate.apiKey'='<your-api-key>' \
        --set-string 'stackstate.cluster.name'='<your-cluster-name>' \
        --set-string 'stackstate.cluster.authToken=<your-cluster-token>' \
        --set-string 'stackstate.url'='<stackstate-receiver-api-address>' \
        --values values.yaml \
        stackstate-cluster-agent stackstate/cluster-agent    
    ```

    Additional variables can be added to the standard helm command, for example:
    * It is recommended to [provide a `stackstate.cluster.authToken`](/setup/agent/kubernetes.md#stackstateclusterauthtoken). 
    * If you use a custom socket path, [set the `agent.containerRuntime.customSocketPath`](/setup/agent/kubernetes.md#agentcontainerruntimecustomsocketpath). 
    * Details of all available helm chart values can be found in the [Cluster Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent).

### Helm chart values

{% hint style="info" %}
Details of all available helm chart values can be found in the [Cluster Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent).
{% endhint %}

### Prerequisites

To set up the StackState AWS integration, you need to have:

* The following [AWS accounts](aws.md#aws-accounts):
  * At least one target AWS account that will be monitored.
  * An AWS account for the StackState Agent to use when retrieving data from the target AWS accounts. It is recommended to use a separate shared account for this and not use any of the accounts that will be monitored by StackState.
* AWS EKS cluster and node group with [EKS IAM role](aws-sts-eks.md#stackstate-iam-role-for-eks) attached to the node group.

### Configure the AWS Cluster Check

To enable the AWS check and begin collecting data from AWS, add the following configuration to StackState Agent V2:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/aws_topology.d/conf.yaml` to include details of your AWS instances:

    - **aws_access_key_id** - The AWS Access Key ID. Leave empty quotes if the Agent is running on an [EC2 instance with an IAM role attached](#iam-role-for-agent-on-ec2).
    - **aws_secret_access_key** - The AWS Secret Access Key. Leave empty quotes if the Agent is running on an [EC2 instance with an IAM role attached](#iam-role-for-agent-on-ec2).
    - **external_id** - The same external ID used to create the CloudFormation stack in every account and region.
    - **role_arn** - In the example `arn:aws:iam::123456789012:role/StackStateAwsIntegrationRole`, substitute 123456789012 with the target AWS account ID to read.
    - **regions** - The Agent will only attempt to find resources in the specified regions. `global` is a special region for global resources, such as Route53.

    ```yaml
    clusterChecks:
    # clusterChecks.enabled -- Enables the cluster checks functionality _and_ the clustercheck pods.
    enabled: true

    clusterAgent:
      config:
        override:
    #clusterAgent.config.override -- Defines kubernetes_state check for clusterchecks agents. Auto-discovery
    #with ad_identifiers does not work here. Use a specific URL instead.
        - name: conf.yaml
          path: /etc/stackstate-agent/conf.d/aws_topology.d
          data: |
            cluster_check: true

            init_config:
            aws_access_key_id: 'use-role'
            aws_secret_access_key: 'use-role'
            external_id: uniquesecret!1 
            # full_run_interval: 3600

            instances:
            - role_arn: arn:aws:iam::123456789012:role/StackStateAwsIntegrationRole
                regions:
                - global
                - eu-west-1
                collection_interval: 60 # The amount of time in seconds between each scan. Decreasing this value will not appreciably increase topology update speed.
                # apis_to_run:
                #   - ec2
                # log_bucket_name: '' 
                # tags:
                #   - foo:bar
   ```

2. You can also add optional configuration and filters: 
    - **full_run_interval** - Optional. The time in seconds between a full AWS topology scan. Intermediate runs only fetch events.
    - **collection_interval** - The amount of time in seconds between each scan. Decreasing this value will not appreciably increase topology update speed.
    - **apis_to_run** - Optionally whitelist specific AWS services. It is not recommended to set this; instead rely on IAM permissions.
    - **log_bucket_name** - The S3 bucket that the agent should read events from. This value should only be set in custom implementations.
    - **tags** - Optional. Can be used to apply specific tags to all reported data in StackState.

3. [Restart the StackState Agent](/setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) to apply the configuration changes.
4. Once the Agent has restarted, wait for data to be collected from AWS and sent to StackState.

## Uninstall

To uninstall the StackState Cluster Agent and the StackState Agent from your Kubernetes cluster, run a Helm uninstall:

```text
helm uninstall <release_name> --namespace <namespace>

# If you used the standard install command provided when you installed the StackPack
helm uninstall stackstate-cluster-agent --namespace stackstate
```

## See also

* [Cluster Agent Helm Chart documentation \(github.com\)](https://github.com/StackVista/helm-charts/tree/master/stable/cluster-agent)
* [About the StackState Agent](about-stackstate-agent.md)
* [Advanced Agent configuration](advanced-agent-configuration.md)  
* [Kubernetes StackPack](../../stackpacks/integrations/kubernetes.md)