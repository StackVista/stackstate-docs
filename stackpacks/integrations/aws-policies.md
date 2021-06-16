# AWS IAM policies

## Overview 

This page includes examples of all IAM and other policies necessary for a working StackState AWS Agent installation. These policies are taken directly from the CloudFormation template and should be used wherever possible.

To use a template:

* Replace `${Region}` with the name of the region that the IAM role will be used for, such as `${Region}` or `us-east-1`. 
* Replace `${AccountId}` with the 12-digit AWS account ID of the AWS account that the resources will be deployed in.

## StackStateAwsIntegrationRole

The JSON objects below contains the least-privilege IAM policy used by the AWS integration. The Assume Role Policy Document should grant the agent access. Refer to the AWS documentation for more information on [setting a trust policy \(aws.amazon.com\)](https://aws.amazon.com/blogs/security/how-to-use-trust-policies-with-iam-roles/).

### Trust Relationship

For an AWS agent running outside of AWS, using an IAM user. Replace the Principal with the IAM user or AWS account that the agent is using.

``` json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${AccountId}:root"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${ExternalId}"
        }
      }
    }
  ]
}
```

For an AWS agent running on an EC2 instance:

```json
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

### IAM Policy Document

``` json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudformation:GetTemplate"
            ],
            "Resource": "arn:aws:cloudformation:*:${AccountId}:stack/stackstate-resources/*",
            "Effect": "Allow",
            "Sid": "SelfAccess"
        },
        {
            "Action": [
                "cloudwatch:GetMetricData",
                "cloudwatch:ListMetrics"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "MetricsAccess"
        },
        {
            "Action": [
                "cloudtrail:LookupEvents",
                "events:DescribeApiDestination",
                "events:DescribeArchive",
                "events:DescribeConnection",
                "events:DescribeEventBus",
                "events:DescribeReplay",
                "events:DescribeRule",
                "events:ListApiDestinations",
                "events:ListArchives",
                "events:ListConnections",
                "events:ListEventBuses",
                "events:ListEventSources",
                "events:ListReplays",
                "events:ListRules",
                "events:ListTagsForResource",
                "events:ListTargetsByRule",
                "iam:GetAccountAuthorizationDetails"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "EventsAccess"
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:DeleteObject"
            ],
            "Resource": [
                "aws:aws:s3:::stackstate-logs-${AccountId}",
                "arn:aws:s3:::stackstate-logs-${AccountId}/*"
            ],
            "Effect": "Allow",
            "Sid": "EventsS3Access"
        },
        {
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeIdFormat",
                "ec2:DescribeReservedInstancesOfferings",
                "ec2:DescribeFleetInstances",
                "ec2:DescribeVpcEndpointServiceConfigurations",
                "ec2:DescribePrefixLists",
                "ec2:GetReservedInstancesExchangeQuote",
                "ec2:DescribeInstanceCreditSpecifications",
                "ec2:DescribeVolumeAttribute",
                "ec2:DescribeImportSnapshotTasks",
                "ec2:DescribeVpcEndpointServicePermissions",
                "ec2:DescribeScheduledInstances",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeFleets",
                "ec2:DescribeElasticGpus",
                "ec2:DescribeReservedInstancesModifications",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpnGateways",
                "ec2:DescribeFleetHistory",
                "ec2:DescribeAddresses",
                "ec2:DescribePrincipalIdFormat",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeRegions",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeSpotPriceHistory",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeVpcEndpointConnections",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeHostReservations",
                "ec2:DescribeIamInstanceProfileAssociations",
                "ec2:DescribeTags",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:DescribeBundleTasks",
                "ec2:DescribeClassicLinkInstances",
                "ec2:DescribeIdentityIdFormat",
                "ec2:DescribeImportImageTasks",
                "ec2:DescribeNatGateways",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeVpcEndpointConnectionNotifications",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSpotFleetRequests",
                "ec2:DescribeHosts",
                "ec2:DescribeImages",
                "ec2:DescribeFpgaImages",
                "ec2:DescribeSpotFleetInstances",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeVpcs",
                "autoscaling:Describe*",
                "ec2:DescribeVpnGateways",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DescribeListeners"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "Ec2Access"
        },
        {
            "Action": [
                "redshift:DescribeClusters"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "RedshiftAccess"
        },
        {
            "Action": [
                "ecs:ListAttributes",
                "ecs:ListTasks",
                "ecs:ListContainerInstances",
                "ecs:DescribeContainerInstances",
                "ecs:DescribeTasks",
                "ecs:DescribeClusters",
                "ecs:ListServices",
                "ecs:ListTaskDefinitionFamilies",
                "ecs:DescribeServices",
                "ecs:DescribeTaskDefinition",
                "ecs:ListTaskDefinitions",
                "ecs:ListClusters",
                "servicediscovery:List*",
                "servicediscovery:Get*"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "EcsAccess"
        },
        {
            "Action": [
                "firehose:DescribeDeliveryStream",
                "firehose:ListDeliveryStreams",
                "firehose:ListTagsForDeliveryStream"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "Accessfirehose"
        },
        {
            "Action": [
                "s3:ListBucketByTags",
                "s3:ListBucket",
                "s3:GetBucketNotification",
                "s3:GetBucketLocation",
                "s3:GetBucketTagging",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "S3Access"
        },
        {
            "Action": [
                "rds:ListTagsForResource",
                "rds:DescribeDBParameters",
                "rds:DescribeDBParameterGroups",
                "rds:DescribeDBClusters",
                "rds:DescribeDBInstances",
                "rds:DescribeEngineDefaultClusterParameters",
                "rds:DescribeEngineDefaultParameters",
                "rds:DescribeEventCategories",
                "rds:DescribeAccountAttributes"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "RdsAccess"
        },
        {
            "Action": [
                "route53domains:GetDomainDetail",
                "route53domains:ListDomains",
                "route53domains:ListTagsForDomain",
                "route53:ListHostedZones",
                "route53:ListTagsForResource",
                "route53:GetHostedZone",
                "route53:ListResourceRecordSets"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "Route53Access"
        },
        {
            "Action": [
                "lambda:GetFunction",
                "lambda:ListAliases",
                "lambda:ListEventSourceMappings",
                "lambda:ListFunctions",
                "lambda:ListTags",
                "lambda:ListVersionsByFunction"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "LambdaAccess"
        },
        {
            "Action": [
                "sns:GetTopicAttributes",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTagsForResource",
                "sns:ListTopics"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "SnsAccess"
        },
        {
            "Action": [
                "sqs:ListQueues",
                "sqs:GetQueueUrl",
                "sqs:GetQueueAttributes",
                "sqs:ListQueueTags"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "SqsAccess"
        },
        {
            "Action": [
                "dynamodb:DescribeTable",
                "dynamodb:ListTagsOfResource",
                "dynamodb:ListTables"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "DynamoDbAccess"
        },
        {
            "Action": [
                "kinesis:DescribeStreamSummary",
                "kinesis:ListTagsForStream",
                "kinesis:ListStreams"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "KinesisAccess"
        },
        {
            "Action": [
                "apigateway:DELETE",
                "apigateway:PUT",
                "apigateway:HEAD",
                "apigateway:PATCH",
                "apigateway:POST",
                "apigateway:GET",
                "apigateway:OPTIONS"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "ApiGatewayAccess"
        },
        {
            "Action": [
                "cloudformation:DescribeStacks",
                "cloudformation:DescribeStackResources"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "CloudFormationAccess"
        },
        {
            "Action": [
                "states:DescribeActivity",
                "states:ListStateMachines",
                "states:DescribeStateMachine",
                "states:ListActivities",
                "states:ListTagsForResource"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "StepFunctionsAccess"
        }
    ]
}
```

## StackStateEventBridgeRole-${Region}

### rust Relationship

``` json
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

### IAM Policy Document

Replace the Resource with the ARN of the target Kinesis Firehose Delivery Stream.

``` json
{
    "Statement": [
        {
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource": [
                "arn:aws:firehose:${Region}:${AccountId}:deliverystream/stackstate-eventbridge-stream"
            ],
            "Effect": "Allow"
        }
    ]
}
```

## StackStateFirehoseRole-${Region}

### Trust Relationship

``` json
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

### IAM Policy Document

The Condition and KMS sections are only needed if a KMS key is used. This assumes that the S3 bucket is named `stackstate-logs-${AccountId}`

``` json
{
    "Statement": [
        {
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::stackstate-logs-${AccountId}/AWSLogs/${AccountId}/EventBridge/${Region}/*",
                "arn:aws:s3:::stackstate-logs-${AccountId}"
            ],
            "Effect": "Allow"
        },
        {
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "s3.${Region}.amazonaws.com"
                },
                "ArnLike": {
                    "kms:EncryptionContext:aws:s3:arn": "arn:aws:s3:::stackstate-logs-${AccountId}/AWSLogs/${AccountId}/EventBridge/${Region}/*"
                }
            },
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": [
                "arn:aws:kms:${Region}:${AccountId}:alias/stackstate-integration"
            ],
            "Effect": "Allow"
        }
    ]
}
```

## StsEventBridgeRule

``` json
{
    "detail-type": [
        "EC2 Instance State-change Notification",
        "AWS API Call via CloudTrail"
    ],
    "source": [
        "aws.apigateway",
        "aws.application-autoscaling",
        "aws.dynamodb",
        "aws.ec2",
        "aws.ecs",
        "aws.elasticloadbalancing",
        "aws.firehose",
        "aws.kinesis",
        "aws.lambda",
        "aws.rds",
        "aws.redshift",
        "aws.s3",
        "aws.sqs",
        "aws.states"
    ]
}
```

## stackstate-integration KMS Key

By default this KMS key gives full access to any IAM user within the account to administer the key. This can be modified as necessary to meet your organization's security policies.

``` json
{
    "Version": "2012-10-17",
    "Id": "default",
    "Statement": [
        {
            "Sid": "AllowKeyAdministration",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${AccountId}:root"
                ]
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowS3Access",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey",
                "kms:Encrypt",
                "kms:GenerateDataKey*",
                "kms:ReEncrypt*"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "s3.${Region}.amazonaws.com"
                }
            }
        },
        {
            "Sid": "AllowVpcFlowLogAccess",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey",
                "kms:Encrypt",
                "kms:GenerateDataKey*",
                "kms:ReEncrypt*"
            ],
            "Resource": "*"
        }
    ]
}
```
