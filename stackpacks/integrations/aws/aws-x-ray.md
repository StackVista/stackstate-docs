---
description: StackState SaaS
---

# AWS X-ray

## Overview

AWS X-Ray is a service that collects data about requests that your application serves, and provides tools you can use to view, filter, and gain insights into that data to identify issues, and opportunities for optimization.

AWS services integrate with AWS X-Ray by adding a tracing header to requests, running the X-Ray daemon, or making sampling decisions, and uploading trace data to X-Ray. The X-Ray SDKs include plugins for additional integration with AWS services.


## Functionality

The StackState AWS X-Ray integration provides the following functionality:

* Enriches AWS components with X-Ray trace service data.
* Allows mapping the relations between X-Ray services, and ultimately AWS resources.
* Provides performance metrics on relations between X-Ray services, as well as local anomaly detection on all performance metrics.

## Setup

To get X-Ray traces you need to attach policy **AWSXrayFullAccess** to the AWS service roles in the IAM console. Check [AWS X-Ray Developer guide](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html) for more information about setting up X-Ray.

### Installation

The AWS X-Ray check is included in the [Agent V2 StackPack](../agent.md). You also need to install [AWS StackPack](aws.md) to see rest of you AWS topology and metrics.

### Configuration

1. Edit the `aws_xray.d/conf.yaml` file, in the `conf.d/` folder at the root of your Agent's configuration directory to start collecting your Tomcat metrics and logs. See the sample `aws_xray.d/conf.yaml.example` for all available configuration options.
    ```text
    # Section used for global AWS check config
    init_config:
        # optional
        # cache_file: '/opt/stackstate-agent/tmp'
    
    instances:
      # mandatory AWS credentials and config
      - aws_access_key_id: 'abc'
        aws_secret_access_key: 'cde'
        role_arn: 'arn:aws:iam::0123456789:role/RoleName'
        region: 'ijk'
        # optional
        # min_collection_interval: 60 # use in place of collection_interval for Agent V2.14.x or earlier  
        # collection_interval: 60
    ```

2. Restart the Agent.

Need help? Please contact [StackState support](http://support.stackstate.com/).

