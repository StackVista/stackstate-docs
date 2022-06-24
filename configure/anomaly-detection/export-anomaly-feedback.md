---
description: StackState Self-hosted v5.0.x
---

# Export anomaly feedback

## Overview

Feedback that has been added to anomalies reported by the Autonomous Anomaly Detector can be exported to file using the StackState CLI. Exported data can be sent on to the StackState team for investigation.

## Export feedback

To export anomaly feedback from StackState, the [StackState CLI](/setup/cli/README.md) is required. When an export is run, all feedback and comments for all anomalies reported in the specified time window will be exported.

{% hint style="warning" %}
**Note that any user comments will be included in the exported feedback.** These comments are very useful, but should not contain any sensitive information.
{% endhint %}

{% tabs %}
{% tab title="CLI: sts (new)" %}

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)

Using StackState CLI `sts` (new), anomaly feedback can be exported from StackState with the command `sts anomaly collect-feedback`. 

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
{% tab title="CLI: stac" %}

Using StackState CLI `stac`, anomaly feedback can be exported from StackState with the command `stac anomaly collect-feedback`. 

For example:

```commandline
# Export all feedback on all anomalies in the last 7 days,
# include 1 day of metric data for each anomaly
stac anomaly collect-feedback --start-time=-7d > feedback.json

# Export all feedback on anomalies from 10 to 2 days ago,
# include 3 days of metric data for each anomaly
stac anomaly collect-feedback --start-time=-10d --end-time=-2d --history=3d > feedback.json
```
**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% endtabs %}

## Send exported feedback

When requested, feedback exported from StackState can be sent on to the StackState team. Instructions on how to do this using a secure fileshare will be provided to you. All data received will be handled in accordance with the StackState security policy.

{% hint style="warning" %}
**Note that any user comments will be included in the exported feedback.** These comments are very useful, but should not contain any sensitive information.
{% endhint %}

## See also

* [Add feedback to anomalies](/stackpacks/add-ons/aad.md#anomaly-feedback)
