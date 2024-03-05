---
description: StackState SaaS
---

# Policies for AWS

## Overview

{% hint style="info" %}
This page includes examples of all IAM and other policies necessary for a working StackState AWS Agent installation. For the AWS \(legacy\) integration, refer to the policy files provided when the AWS \(legacy\) StackPack is installed.
{% endhint %}

These policies are taken directly from the CloudFormation template and should be used wherever possible.

To use a template, replace the following values:

* **${Region}** - replace with the name of the region that the IAM role will be used for, such as `${Region}` or `us-east-1`. 
* **${AccountId}** - replace with the 12-digit AWS account ID of the AWS account that the resources will be deployed in.

## StackStateAwsIntegrationRole

The JSON objects below include the least-privileged IAM policy used by the AWS integration. The Assume Role Policy Document should grant the Agent access. Refer to the AWS documentation for more information on [setting a trust policy \(aws.amazon.com\)](https://aws.amazon.com/blogs/security/how-to-use-trust-policies-with-iam-roles/).

### Trust Relationship

For an AWS Agent running outside of AWS, using an IAM user. Replace the Principal with the IAM user or AWS account that the Agent is using.

```javascript
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

For an AWS Agent running on an EC2 instance:

```javascript
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

```javascript
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudtrail:LookupEvents",
                "iam:ListAccountAliases"
            ],
            "Resource": "*",
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
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::stackstate-logs-${AccountId}",
                "arn:aws:s3:::stackstate-logs-${AccountId}/*"
            ],
            "Effect": "Allow",
            "Sid": "EventsS3Access"
        },
        {
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpnGateways",
                "ec2:DescribeNetworkInterfaces"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "Ec2Access"
        },
        {
            "Action": [
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "LoadBalancingAccess"
        },
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AutoScalingAccess"
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
                "ecs:DescribeClusters",
                "ecs:DescribeContainerInstances",
                "ecs:DescribeServices",
                "ecs:DescribeTasks",
                "ecs:ListClusters",
                "ecs:ListContainerInstances",
                "ecs:ListServices",
                "ecs:ListTasks"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "EcsAccess"
        },
        {
            "Action": [
                "servicediscovery:GetNamespace",
                "servicediscovery:GetService",
                "servicediscovery:ListInstances",
                "servicediscovery:ListServices"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "ServiceDiscoveryAccess"
        },
        {
            "Action": [
                "firehose:DescribeDeliveryStream",
                "firehose:ListDeliveryStreams",
                "firehose:ListTagsForDeliveryStream"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "FirehoseAccess"
        },
        {
            "Action": [
                "s3:GetBucketNotification",
                "s3:GetBucketTagging",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:GetBucketVersioning"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "S3Access"
        },
        {
            "Action": [
                "rds:DescribeDBClusters",
                "rds:DescribeDBInstances"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "RdsAccess"
        },
        {
            "Action": [
                "route53:GetHostedZone",
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets",
                "route53:ListTagsForResource",
                "route53domains:GetDomainDetail",
                "route53domains:ListDomains",
                "route53domains:ListTagsForDomain"
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
                "lambda:ListTags"
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
                "sqs:GetQueueAttributes",
                "sqs:ListQueues",
                "sqs:ListQueueTags"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "SqsAccess"
        },
        {
            "Action": [
                "dynamodb:DescribeTable",
                "dynamodb:ListTables",
                "dynamodb:ListTagsOfResource"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "DynamoDbAccess"
        },
        {
            "Action": [
                "kinesis:DescribeStreamSummary",
                "kinesis:ListStreams",
                "kinesis:ListTagsForStream"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "KinesisAccess"
        },
        {
            "Action": [
                "apigateway:GET"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "ApiGatewayAccess"
        },
        {
            "Action": [
                "cloudformation:DescribeStackResources",
                "cloudformation:DescribeStacks"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "CloudFormationAccess"
        },
        {
            "Action": [
                "states:DescribeStateMachine",
                "states:ListActivities",
                "states:ListStateMachines",
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

### Trust Relationship

```javascript
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

```javascript
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

```javascript
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

```javascript
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

```javascript
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

By default, this KMS key gives full access to any IAM user within the account to administer the key. This can be modified as necessary to meet your organization's security policies.

```javascript
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

