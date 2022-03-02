# OpenTelemetry - AWS - NodeJS

## Overview

StackState provides an out-of-the-box OpenTelemetry solution by providing a modified OpenTelemetry Lambda Layer (Based on the officially released [AWS Distro for OpenTelemetry Lambda](https://aws-otel.github.io/docs/getting-started/lambda)) that gives a plug-and-play user experience.

Your Lambda function can include this OpenTelemetry Lambda Layer solution to collect trace data without changing any code.

## Setup

### Prerequisites

To set up OpenTelemetry traces, you need to have:
* AWS Lambda scripts running `NodeJS 14.x (or later)`
  * These will be the Lambda you wish to add OpenTelemetry support to.
* [AWS v2 StackPack](../../../../stackpacks/integrations/aws/aws.md) installed. The AWS StackPack will deploy the latest supported OpenTelemetry Lambda Layer which is required for AWS OpenTelemetry functionality.
* [StackState Agent V2](../../../../setup/agent/about-stackstate-agent.md) installed on a machine, Your AWS lambda should be able to communicate with this Agent.


## Installation

### Install the OpenTelemetry Lambda Layer

* Head over to your [AWS Lambda Layers](https://console.aws.amazon.com/lambda/home#/layers) page.
    * Change the region in the top-right corner to the region where you deployed the [AWS StackPack](../../../../stackpacks/integrations/aws/aws.md) cloudformation template.
* Verify that there's a Lambda Layer called `stackstate-otel-nodejs` within the list
    * If the Lambda Layer is not present, then the AWS v2 StackPack that's installed may not be the latest one containing the Lambda Layer.
    * Follow the [AWS v2 StackPack](../../../../stackpacks/integrations/aws/aws.md) documentation to verify the installation of this StackPack
* Head over to your [Lambda functions](https://console.aws.amazon.com/lambda/home#/functions) page and navigate to the Lambda you wish to add OpenTelemetry support to.
* Underneath the `Code` tab, scroll down to the `Layers` section and click the `Add a layer` button on the right side.
* Select the `Custom Layer` radio box under the `Choose a layer` section. This will show two dropdowns at the very bottom of the page.
* In the first dropdown, select the Lambda Layer `stackstate-otel-nodejs`
* In the second dropdown, select the Latest possible version number, and click the `Add` button in the bottom right corner
    * Your Lambda function now contains the OpenTelemetry code. The next step is to configure the OpenTelemetry Lambda Layer with environment variables to produce and send the data to an agent. You can follow the docs under [this link to configure the OpenTelemetry Lambda Layer](../../../../configure/traces/open-telemetry/aws/nodejs.md)

## See also



