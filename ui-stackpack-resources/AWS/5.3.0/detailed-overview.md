### Prerequisites

To set up the StackState AWS integration, you need to have:

* AWS CLI version 2.0.4 or later installed and configured.
* An AWS user with the required access to retrieve Cloudwatch metrics:

    - `cloudwatch:GetMetricData`
    - `cloudwatch:ListMetrics`

* An AWS user with the required access rights to install StackState monitoring in your account. Policy files to create a user with the correct rights are available to download after a StackPack instance has been installed.

#### Proxy URL

If your StackState instance is behind a proxy, you need to configure the proxy URL and port for the AWS authorization to work.
You can configure a proxy URL environment variable or JVM system property.

- Environment variable `HTTP_PROXY` and/or `HTTPS_PROXY`
- Pass following properties when starting StackState instance `-Dhttp.proxyHost -Dhttp.proxyPort` and/or `-Dhttps.proxyHost -Dhttps.proxyPort`

### Costs

The AWS lightweight agent uses Amazon resources (Lambda and Kinesis) for which Amazon will charge a minimal fee. Amazon also charges a fee for the use of CloudWatch metrics. Metrics are only retrieved when viewed or when a check is configured on a CloudWatch metric.

### Timeout
The default read timeout for AWS is set to 30 seconds. You can specify custom read timeout with the `AWS_CLI_READ_TIMEOUT` environment variable. 

### Data retrieved

#### Events

The AWS integration does not retrieve any Events data.

#### Metrics

Metrics data is pulled at a configured interval directly from AWS by the StackState CloudWatch plugin. Retrieved metrics are mapped onto the associated topology component.

#### Topology

Each AWS integration retrieves topology data for resources associated with the associated AWS access key.

##### Components

The following AWS service data is available in StackState as components:

| | | |
|:--- |:--- |:--- |
| API Gateway Resource | API Gateway Stage | API Getaway Method |
| AutoScaling Group | CloudFormation Stack | DynamoDB Stream |
| DynamoDB Table | EC2 Instance | ECS Cluster |
| ECS Service | ECS Task | Firehose Delivery Stream |
| Kinesis Stream | Lambda | Lambda Alias |
| Load Balancer Classic | Load Balancer V2 | RDS Instance |
| Redshift Cluster | Route53 Domain | Route53 Hosted Zone |
| S3 bucket | Security Group | SNS Topic |
| SQS Queue | Subnet | Target Group |
| Target Group Instance | VPC | VPN Gateway |

##### Relations

The following relations between components are retrieved:

* API Gateway Method → (Service) Integration Resource (varies)
* API Gateway Resource → API Gateways Method
* API Gateway Stage → API Gateway Resource
* AutoScaling Group → EC2 Instance, Load Balancer Classic
* CloudFormation Stack → Any Resource (many supported), CloudFormation Stack Parent
* DynamoDB Table → DynamoDB Stream
* EC2 Instance → Security Group, Subnet, VPC
* ECS Cluster → EC2 Instance, ECS Task (when no group service)
* ECS Service → ECS Cluster, ECS Task, Route53 Hosted Zone, Target Group
* ECS Task → ECS Cluster
* Firehose Delivery Stream → Kinesis Source, S3 Bucket Destination(s)
* Lambda → Event Source Mapping, Security Group, VPC
* Lambda Alias → VPC
* Load Balancer Classic → EC2 Instance, VPC
* Load Balancer V2 → Security Group, Target Group, VPC
* RDS Cluster → RDS Instance
* RDS Instance → Security Group, VPC
* Redshift Cluster → VPC
* S3 Bucket → Lambda (notification configuration of the bucket)
* Security Group → VPC
* SNS Topic → Subscription
* Subnet → VPC
* Target Group → AutoScaling Group, EC2 Instance, VPC
* VPN Gateway → VPC

#### Traces

The AWS integration does not retrieve any Traces data.

### AWS lambdas

The StackState AWS integration installs the following AWS lambdas:

| Lambda | Description |
|:---|:---|
| `stackstate-topo-cron` | Scans the initial topology based on an interval schedule and pushes to StackState. |
| `stackstate-topo-cwevents` | Listens to CloudWatch events, transforms the events and publishes them to Kinesis. Full install only.|
| `stackstate-topo-publisher` | Pushes topology from a Kinesis stream to StackState. Full install only. |

### AWS views in StackState

When the AWS integration is enabled, three [views](https://l.stackstate.com/ui-aws-views) will be created in StackState for each instance of the StackPack.

- **AWS - \[instance_name\] - All** - includes all resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Infrastructure** - includes only Networking, Storage and Machines resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Serverless** - includes only S3 buckets, lambdas and application load balancers retrieved from AWS by the StackPack instance.

### AWS actions in StackState

Components retrieved from AWS will have an additional [action](https://l.stackstate.com/ui-aws-actions) available in the component context menu and in the right panel when a component has been selected to show its detailed information. This provides a deep link through to the relevant AWS console at the correct point.

For example, in the StackState topology perspective: 

- Components of type aws-subnet have the action **Go to Subnet console**, which links directly to this component in the AWS Subnet console.
- Components of type ec2-instance have the action **Go to EC2 console**, which links directly to this component in the EC2 console.

### Tags and labels

The AWS StackPack converts tags in AWS to labels in StackState. In addition, the following special tags are supported:

| Tag | Description |
| :--- | :--- |
| `stackstate-identifier` | Adds the specified value as an identifier to the StackState component |
| `stackstate-environment` | Places the StackState component in the environment specified |

