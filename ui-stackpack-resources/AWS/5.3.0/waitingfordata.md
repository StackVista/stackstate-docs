## The AWS StackPack is waiting for data

### Deploy AWS Cloudformation stacks

The StackState AWS Cloudformation stacks are deployed on your AWS account to enable topology monitoring. There are two options for StackState monitoring:

* [**Full install**](#full-install) - all changes to AWS resources will be picked up and pushed to StackState.
* [**Minimal install**](#minimal-install) - changes will be picked up only at a configured interval.

#### Full install

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

#### Minimal install

The minimal installation is useful when less permissions are available. This installs only the `stackstate-topo-cron` Cloudformation stack, which means StackState's topology will only get a full topology update every hour. Updates between the hour are not sent to StackState. 

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

## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://l.stackstate.com/ui-aws-support-kb).

