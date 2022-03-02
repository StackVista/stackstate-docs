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

TODO: Add Images

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
* TODO:
  * Explain X-ray or Pass through cli command entry
* TODO:
  * CLI function to confirm your lambda structure
* Great, Your Lambda function now contains the OpenTelemetry Lambda Layer code, although still inactive. The next step is to configure your Lambda function with environment variables to produce and send the data to an agent. You can follow the docs under [this link to configure the OpenTelemetry Lambda Layer](../../../../configure/traces/open-telemetry/aws/nodejs.md)

## Disabling OpenTelemetry Traces

To disable OpenTelemetry tracing you can simply head over to your Lambda's `configuration` tab and under the `Environment variables` section remove the environment variable called `AWS_LAMBDA_EXEC_WRAPPER` this will disable the code routing through the OpenTelemetry Lambda Layer.

## Upgrade

To upgrade your OpenTelemetry Lambda Layer to tha the latest version, including your Lambda function using them the layer follow these steps:

* Make sure you installed the latest [AWS v2 StackPack](../../../../stackpacks/integrations/aws/aws.md)
* After you installed the latest StackPack there should be a new version for the `stackstate-otel-nodejs` lambda layer
  * This can be confirmed by heading over to your [AWS Lambda Layers](https://console.aws.amazon.com/lambda/home#/layers) page
  * Clicking on the `stackstate-otel-nodejs` layer to enter and view the details of the layer
  * The `Created` box on the right side should have a relative new time when it was created.
  * Alternatively you can head over to any of you current Lambda Functions that is currently using the `stackstate-otel-nodejs` layer and compare what version they are using against the version that is displayed under the `Version` block for the layer.
* Head over to all your Lambda functions using the OpenTelemetry `stackstate-otel-nodejs` layer 
  * Scroll down to the `Layers` section, and click the `Edit` button on the right side
  * Change the version for the `stackstate-otel-nodejs` layer to the latest version.

## Uninstall

TODO:

## Problems, Solutions and Debugging

TODO:

## See also



