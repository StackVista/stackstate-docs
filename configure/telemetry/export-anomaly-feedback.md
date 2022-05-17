---
description: StackState Self-hosted v4.6.x
---

# Export anomaly feedback

## Overview

Feedback that has been added to anomalies reported by the Autonomous Anomaly Detector can be exported to file using the StackState CLI. Exported data can be sent on to StackState for investigation when requested using a secure fileshare. All data received will be handled in accordance with the StackState security policy.

{% hint style="warning" %}
**Note that any user comments will be included in the exported feedback.** These are very useful, but should not contain any sensitive information.
{% endhint %}

## Export feedback

To export anomaly feedback from StackState, v1 or v2 of the [StackState CLI](/setup/cli-install.md) is required. When an export is run, all feedback and comments for all anomalies reported in the specified time window will be exported.

{% tabs %}
{% tab title="CLI: sts (legacy)" %}

Using StackState CLI v1, anomaly feedback can be exported from StackState with the command `sts anomaly collect-feedback`. 

For example:

```commandline
# Export all feedback on all anomalies in the last 7 days,
# include 1 day of metric data for each anomaly
sts anomaly collect-feedback --start-time=-7d > feedback.json

# Export all feedback on anomalies from 10 to 2 days ago,
# include 3 days of metric data for each anomaly
sts anomaly collect-feedback --start-time=-10d --end-time=-2d --history=3d > feedback.json
```
{% endtab %}
{% tab title="CLI: stackstate" %}

Using StackState CLI v2, anomaly feedback can be exported from StackState with the command `sts anomaly collect-feedback`. 

For example:

```commandline
# Export all feedback on all anomalies in the last 7 days,
# include 1 day of metric data for each anomaly
sts anomaly collect-feedback --start-time -7d --file feedback.json

# Export all feedback on anomalies from 10 to 2 days ago,
# include 3 days of metric data for each anomaly
sts anomaly collect-feedback --start-time -10d --end-time -2d --history 3d --file feedback.json
```
{% endtab %}
{% endtabs %}

## See also

* [Add feedback to anomalies](/stackpacks/add-ons/aad.md#anomaly-feedback)
