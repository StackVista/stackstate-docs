# CloudWatch

## Overview

TODO

## Pull telemetry from AWS CloudWatch

### Prerequisites

To connect StackState to an AWS CloudWatch instance and retrieve telemetry data you will need to have:

- ???

### Add an AWS CloudWatch data source

A CloudWatch data source should be added in StackState for each AWS CloudWatch account and region that you want to work with. Default settings that should work with most AWS CloudWatch setups are already included, so you will only need to add details of your AWS CloudWatch instance and the index to be retrieved.

To add a CloudWatch data source:

1. In the StackState UI, go to **Settings** &gt; **Telemetry Sources** &gt; **CloudWatch sources**.
2. Click on **ADD CLOUDWATCH SOURCE**.
3. Enter the required settings:
   - **Name** - For example, `CloudWatch source from account x`.
   - **Authentication** - Select from:
     - IAM User Access Keys - Default. Requires:
       - **AccessKeyId** - 
       - **SecretAccessKey** -
     - IAM User Access Keys (Instance Profile). No additional authentication details are required.
     - IAM Role - Requires:
       - **AccessKeyId** - 
       - **SecretAccessKey** -
       - **RoleARN** - The ARN of the IAM role you want to use for the CloudWatch integration.
       - **RoleSessionName** - The session name of the IAM role you want to use for the CloudWatch integration.
       - **ExternalId** - The external ID used by the IAM role you want to use for the CloudWatch integration.
     - IAM Role (Instance Profile) - No additional authentication details are required.
4. Click **TEST CONNECTION** to confirm that StackState can connect to AWS CloudWatch with the configured authentication details.
5. Click **CREATE** to save the CloudWatch data source settings.
   * The new CloudWatch data source will be listed on the **CloudWatch sources** page and available as a data source when adding telemetry to components and relations.

Required with defaults:
   - **Max number of active live streams** - Default `200`. 
   - **Max. number of events retrieved per each live stream poll** - Default `10000`.
   - **Min. live stream polling interval (seconds)** - How often StackState will pull data from the AWS CloudWatch data source. Default `60` seconds.
   - **Max. number of concurrent connections in the executor pool** - Default `100`.
   - **Max. number of pending connections in the executor pool queue** - Default `10000`.
   - **Stale after (minutes)** - Default `10`.

Optional:
- **Description** - For example, `Production CloudWatch account`.
- **Identifier** - Identifiers are URNs used for uniquely identifying nodes and edges (relations) in StackState. Format of an identifier is: `urn:::`. Example: `urn:stackpack:aws:shared:checkfunction:aws-event-run-state` for AWS event run state CheckFunction in the AWS StackPack.

### Use a proxy to connect to AWS CloudWatch

If there is a proxy between StackState and AWS, specify the **Proxy URI** when adding the CloudWatch data source.

For CloudWatch data sources created by the AWS StackPack, ???.


### Work with CloudWatch data in StackState 

TODO

## Advanced settings

### Error management

To reduce noise resulting from intermittent failure of the data source, StackState can be configured to only emit errors after they exist for a specified time.

* **Propagate errors only after \(minutes\)** - the time after which errors should be reported. Default `0`.

### Timeouts 

The timeout settings can be tweaked when dealing with exceptionally large result sets:

- **Connection acquisition timeout - the max time a connection remains in the executor pool queue. (seconds)** - Default `30`.
- **Connection read timeout - the maximum time a connection waits for the server to respond. (seconds)** - Default `30`.
- **Request timeout ui (seconds)** - Default `15`.

## See also

* [AWS StackPack](/stackpacks/integrations/aws/aws.md)