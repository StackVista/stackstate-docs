## The AWS StackPack is installed

Congratulations! The AWS StackPack is configured correctly. Data is being received.

### What's next?

Now that StackState is receiving data from your AWS instance, you can see your topology in the StackState AWS views:

- **AWS - \[instance_name\] - All** - includes all resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Infrastructure** - includes only Networking, Storage and Machines resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Serverless** - includes only S3 buckets, lambdas and application load balancers retrieved from AWS by the StackPack instance.

Components retrieved from AWS will have an additional action available in the component context menu and in the right panel **Selection details** tab when a component has been selected to show its detailed information. This provides a deep link through to the relevant AWS console at the correct point. For example, in the StackState Topology Perspective: 

- Components of type aws-subnet have the action **Go to Subnet console**, which links directly to this component in the AWS Subnet console.
- Components of type ec2-instance have the action **Go to EC2 console**, which links directly to this component in the EC2 console.

Find out more in the [AWS StackPack documentation](https://l.stackstate.com/ui-aws-docs).

## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://l.stackstate.com/ui-aws-support-kb).

## Uninstall

To uninstall the StackState AWS StackPack, click the *Uninstall* button from the StackState UI **StackPacks** &gt; **Integrations**  &gt; **AWS** screen. This will remove all AWS specific configuration in StackState. 

Once the AWS StackPack has been uninstalled, you will need to manually uninstall the StackState AWS Cloudformation stacks from the AWS account being monitored. To execute the manual uninstall follow these steps:

1. Use the following AWS policy files to give correct permissions to uninstall:

   * **Uninstall a full install** - [StackStateIntegrationPolicyUninstall.json](/api/stackpack/aws/resources/{{stackPackVersion}}/StackStateIntegrationPolicyUninstall.json)
   * **Uninstall a minimal install** - [StackStateIntegrationPolicyTopoCronUninstall.json](/api/stackpack/aws/resources/{{stackPackVersion}}/StackStateIntegrationPolicyTopoCronUninstall.json)

2. Download the manual installation zip file and extract it: [stackstate-aws-manual-installation-{{stackPackVersion}}.zip](/api/stackpack/aws/resources/{{stackPackVersion}}/stackstate-aws-manual-installation-{{stackPackVersion}}.zip)

3. Make sure the AWS CLI is configured with the proper account and has the default region set to the region that should be monitored by StackState. For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://l.stackstate.com/ui-aws-cli-configure-role).

4. From the command line, run the below command to deprovision all resources related to the StackPack instance:
```
./uninstall.sh {{configurationId}}
```

If you wish to use a specific AWS profile or an IAM role during uninstallation, run either of these two commands:

```
AWS_PROFILE=profile-name ./uninstall.sh {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./uninstall.sh {{configurationId}}
```

These environment variables have the same names used by the AWS_CLI utility and will be overridden with options:

- `--profile`
- `--role-arn`
- `--session-name`
- `--external-id`

## Reinstall the AWS Cloudformation stacks

The StackState AWS Cloudformation stacks are deployed on your AWS account to enable topology monitoring. In case these have been uninstalled, they can be reinstalled using the instructions provided below. There are two options for StackState monitoring:

* [**Full install**](#full-install) - all changes to AWS resources will be picked up and pushed to StackState.
* [**Minimal install**](#minimal-install) - changes will be picked up only at a configured interval.

### Full install

A full installation will install the following CloudFormation Stacks:

- `stackstate-topo-cron`
- `stackstate-topo-kinesis`
- `stackstate-topo-cloudtrail`
- `stackstate-topo-cwevents`
- `stackstate-topo-publisher`

Follow the steps below to complete a full install:

1. Use the following AWS policy file to give correct permissions to install the lambdas: [StackStateIntegrationPolicyInstall.json](/api/stackpack/aws/resources/{{stackPackVersion}}/StackStateIntegrationPolicyInstall.json)

2. Download the manual installation zip file and extract it: [stackstate-aws-manual-installation-{{stackPackVersion}}.zip](/api/stackpack/aws/resources/{{stackPackVersion}}/stackstate-aws-manual-installation-{{stackPackVersion}}.zip)

3. Make sure that the AWS CLI is configured with the proper account and has the default region set to the region that should be monitored by StackState. For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://l.stackstate.com/ui-aws-cli-configure-role).

4. From the command line, run the command:
    ```
    ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
    ```

If you wish to use a specific AWS profile or an IAM role during installation, run either of these two commands:

```
AWS_PROFILE=profile-name ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```

These environment variables have the same names used by the AWS_CLI utility and will be overridden with options:

- `--profile`
- `--role-arn`
- `--session-name`
- `--external-id`

### Minimal install

The minimal installation is useful when less permissions are available. This installs only the `stackstate-topo-cron` Cloudformation stack, which means StackState's topology will only get a full topology update every hour. Updates between the hour aren't sent to StackState. 

Follow the steps below to complete a minimal install:

1. Use one of the following AWS policy files to give correct permissions to install the lambdas:

    * **Minimal install** - [StackStateIntegrationPolicyTopoCronInstall.json](/api/stackpack/aws/resources/{{stackPackVersion}}/StackStateIntegrationPolicyTopoCronInstall.json)
    * **Minimal set of policies** - [StackStateIntegrationPolicyTopoCronMinimal.json](/api/stackpack/aws/resources/{{stackPackVersion}}/StackStateIntegrationPolicyTopoCronMinimal.json) (S3 bucket and role are provided by user)

2. Download the manual installation zip file and extract it: [stackstate-aws-manual-installation-{{stackPackVersion}}.zip](/api/stackpack/aws/resources/{{stackPackVersion}}/stackstate-aws-manual-installation-{{stackPackVersion}}.zip)

3. Make sure the AWS CLI is configured with the proper account and has the default region set to the region that should be monitored by StackState. For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://l.stackstate.com/ui-aws-cli-configure-role).
 
4. From the command line, run the command:
    ```
    ./install.sh --topo-cron-only {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
    ```
   You can also optionally specify the following:
    - **--topo-cron-bucket** - a custom S3 bucket to be used during deployment.
    - **--topo-cron-role** - a custom AWS IAM role. Note that the role must have an attached policy like that specified in the file `sts-topo-cron-policy.json` included in the manual install zip file.

If you wish to use a specific AWS profile or an IAM role during installation, run either of these two commands:

```
AWS_PROFILE=profile-name ./install.sh --topo-cron-only {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./install.sh --topo-cron-only {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```

These environment variables have the same names used by the AWS_CLI utility and will be overridden with options:

- `--profile`
- `--role-arn`
- `--session-name`
- `--external-id`
