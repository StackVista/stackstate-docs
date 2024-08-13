---
description: Rancher Observability Self-hosted v5.1.x
---

# Export anomaly feedback

## Overview

Feedback that has been added to anomalies reported by the Autonomous Anomaly Detector can be exported to file using the Rancher Observability CLI. Exported data can be sent on to the Rancher Observability team for investigation.

## Export feedback

Use the [Rancher Observability CLI](/setup/cli/README.md) to export anomaly feedback from Rancher Observability. When an export is run, all feedback and comments for all anomalies reported in the specified time window will be exported.

{% hint style="warning" %}
**Note that any user comments will be included in the exported feedback.** These comments are very useful, but should not contain any sensitive information.
{% endhint %}

{% tabs %}
{% tab title="CLI: sts" %}

{% hint style="info" %}
From Rancher Observability v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endhint %}

Using Rancher Observability CLI `sts` (new), anomaly feedback can be exported from Rancher Observability with the command `sts anomaly collect-feedback`.

For example:

```sh
# Export all feedback on all anomalies in the last 7 days,
# include 1 day of metric data for each anomaly
$ sts anomaly collect-feedback --start-time -7d --file feedback.json

# Export all feedback on anomalies from 10 to 2 days ago,
# include 3 days of metric data for each anomaly
$ sts anomaly collect-feedback --start-time -10d --end-time -2d --history 3d --file feedback.json
```
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}
{% hint style="warning" %}
**From Rancher Observability v5.0, the old `sts` CLI is called `stac`.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "Rancher Observability Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "Rancher Observability Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "Rancher Observability Self-Hosted only")
{% endhint %}

Using Rancher Observability CLI `stac`, anomaly feedback can be exported from Rancher Observability with the command `stac anomaly collect-feedback`.

For example:

```sh
# Export all feedback on all anomalies in the last 7 days,
# include 1 day of metric data for each anomaly
$ stac anomaly collect-feedback --start-time=-7d > feedback.json

# Export all feedback on anomalies from 10 to 2 days ago,
# include 3 days of metric data for each anomaly
$ stac anomaly collect-feedback --start-time=-10d --end-time=-2d --history=3d > feedback.json
```


{% endtab %}
{% endtabs %}

## Send exported feedback

When requested, feedback exported from Rancher Observability can be sent on to the Rancher Observability team. Instructions on how to do this using a secure fileshare will be provided to you. All data received will be handled in accordance with the Rancher Observability security policy.

{% hint style="warning" %}
**Note that any user comments will be included in the exported feedback.** These comments are very useful, but should not contain any sensitive information.
{% endhint %}

## See also

* [Add feedback to anomalies](/stackpacks/add-ons/aad.md#anomaly-feedback)
