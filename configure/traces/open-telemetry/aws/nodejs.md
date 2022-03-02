# OpenTelemetry - AWS - NodeJS

## Overview

StackState provides an out-of-the-box OpenTelemetry solution by providing a modified OpenTelemetry Lambda Layer (Based on the officially released [AWS Distro for OpenTelemetry Lambda](https://aws-otel.github.io/docs/getting-started/lambda)) that gives a plug-and-play user experience.

Your Lambda function can include this OpenTelemetry Lambda Layer solution to collect trace data without changing any code.

## Requirements

- AWS Lambda Script running NodeJS 14.x (or later)


## Setup

### Prerequisites

To set up OpenTelemetry traces, you need to have:
* The latest [AWS StackPack](../../../../stackpacks/integrations/aws/aws.md) installed. The AWS StackPack will deploy the latest supported OpenTelemetry Lambda Layer which is required for AWS OpenTelemetry functionality.
* [StackState Agent V2](../../../../setup/agent/about-stackstate-agent.md) installed on a machine, Your AWS lambda should be able to communicate with this Agent.


### Using the OpenTelemetry Lambda Layer  

- Head over to your [AWS Lambda Layers](https://console.aws.amazon.com/lambda/home#/layers) page on AWS.
- Change the region in the top-right corner to the region you installed your [AWS StackPack](../../../../stackpacks/integrations/aws/aws.md) **stackstate-resources** cloudformation template on.

## See also



