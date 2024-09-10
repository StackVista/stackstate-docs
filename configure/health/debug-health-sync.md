---
description: SUSE Observability
---

# Debug health synchronization

## Overview

The [SUSE Observability CLI](/setup/cli/cli-sts.md) can be used to troubleshoot a health synchronization and fix issues that might prevent health data from being correctly ingested and displayed in SUSE Observability. This page describes the general troubleshooting steps to take when debugging a health synchronization, as well as the CLI commands used, and a description of the error messages returned.

## General troubleshooting steps

When debugging the health synchronization there are some common verification steps that can be made no matter what the specific issue is:

1. [Verify that the stream exists](debug-health-sync.md#list-streams).
2. If you are using sub streams, [verify that the substream exists](debug-health-sync.md#list-sub-streams). The response will also show the number of check states on the substream. This lets you know if the data is being ingested and processed.
3. Investigate further:
   * **Stream present** - [Check the stream status](debug-health-sync.md#show-stream-status), this will show the metrics latency of the stream and any [errors](debug-health-sync.md#error-messages).
   * **Streams / sub streams present, but there are no check states** - Confirm that the payload sent to the Receiver API adheres to the [health payload specification](send-health-data/).
   * **No streams / sub streams are present** - Use the CLI command below to verify that health data sent to the Receiver API is arriving in SUSE Observability:

```sh
$ sts topic describe --name sts_health_sync
```

## Common issues

### Check state not visible on the component

There can be two reasons for a check state not to show on a component in SUSE Observability:

* The health check state hasn't been created. Follow the [general troubleshooting steps](debug-health-sync.md#general-troubleshooting-steps) to confirm that the stream / substream has been created and that data is arriving in SUSE Observability.
* The health check state was created, but its `topologyElementIdentifier` doesn't match any `identifiers` from the SUSE Observability topology. Use the CLI command [show substream status](debug-health-sync.md#show-substream-status) to verify if there are any `Check states with identifier which has no matching topology element`.

### Check state slow to update in SUSE Observability

The main reason for this is that the latency of the health synchronization is higher than expected. Use the CLI command [show stream status](debug-health-sync.md#show-stream-status) to confirm the latency of the stream as well as the throughput of messages and specific check operations. It may be necessary to tweak the data sent to the health synchronization, or the frequency with which data is sent.

## Useful CLI commands

### List streams

Returns a list of all current synchronized health streams and the number of sub streams included in each.

```sh
$ sts health list
STREAM URN                                              | STREAM CONSISTENCY MODEL | SUB STREAM COUNT
urn:health:sourceId:streamId                            | REPEAT_SNAPSHOTS         | 1
```

### List sub streams

Returns a list of all sub streams for a given stream URN, together with the number of check states in each.

```sh
$ sts health list -u urn:health:sourceId:streamId
SUB STREAM ID  | CHECK STATE COUNT
subStreamId1   | 1
subStreamId2   | 1
```

### Show stream status

The stream status command returns the aggregated stream latency and throughput metrics. This is helpful when debugging why a health check takes a long time to land on the expected topology elements. It will help diagnose if the frequency of data sent to SUSE Observability should be adjusted. The output includes a section `Errors for non-existing sub streams:` as some errors are only relevant when a substream couldn't be created, for example `StreamMissingSubStream`. Substream errors can be any of the documented [error messages](debug-health-sync.md#error-messages).

```sh
$ sts health status -u urn:health:sourceId:streamId
```

### Show substream status

The substream status provides useful information to verify that SUSE Observability could bind check states sent from an external system to existing topology elements. This information is helpful to debug why a specific check isn't visible on the expected topology element.

```sh
$ sts health status -u urn:health:sourceId:streamId -sub-stream-urn subStreamId3
```

{% hint style="info" %}
A substream status will show the metadata related to the consistency model:
* **Repeat Snapshots** - Show repeat interval and expiry
* **Repeat States** - Show repeat interval and expiry
* **Transactional Increments** - Show checkpoint offset and checkpoint batch index
{% endhint %}

The substream status can be expanded to include details of matched and unmatched check states using the `-t` command line argument. This is helpful to identify any health states that aren't attached to a topology element.
In the example below, `checkStateId2` is listed under `Check states with identifier which has no matching topology element`. This means that it was not possible to match the check state to a topology element with the identifier `server-2`.

```sh
$ sts health status -u urn:health:sourceId:streamId -sub-stream-urn subStreamId3 -t
```

### Delete a health stream

The `delete` stream functionality is helpful while setting up a health synchronization in SUSE Observability. You can use it to experiment, delete the data and start over again clean. You can also delete a stream and drop its data when you are sure that you don't want to keep using it.

```sh
$ sts health delete -u urn:health:sourceId:streamId
```

### Clear health stream errors

The `clear-errors` option removes all errors from a health stream. This is helpful while setting up a health synchronization in SUSE Observability, or, for the case of the `TRANSACTIONAL_INCREMENTS` consistency model, when some errors can't be removed organically. For example, a request to delete a check state might raise an error if the check state isn't known to SUSE Observability. The only way to suppress such an error would be to use the `clear-errors` command.

```sh
$ sts health clear-error -u urn:health:sourceId:streamId
```

## Error messages

{% hint style="info" %}
Errors will be closed once the described issue has been remediated.

For example a `SubStreamStopWithoutStart` will be closed once the health synchronization observes a start snapshot message followed by a stop snapshot message.
{% endhint %}

| Error | Description |
| :--- | :--- |
| **StreamMissingSubStream** | Raised when the health synchronization receives messages without a previous stream setup message as `start_snapshot` or `expiry`. |
| **StreamConsistencyModelMismatch** | Raised when a message is received that belongs to a different consistency model than that specified when the stream was created. |
| **StreamMissingSubStream** | Raised when the health synchronization receives messages with a previous start snapshot in place. |
| **SubStreamRepeatIntervalTooHigh** | Raised when the health synchronization receives a `repeat_interval_s` greater than the configured max of 30 minutes. |
| **SubStreamStartWithoutStop** | Raised when the health synchronization receives a second message to open a snapshot when a previous snapshot was still open. |
| **SubStreamCheckStateOutsideSnapshot** | Raised when the health synchronization receives external check states without previously opening a snapshot. |
| **SubStreamStopWithoutStart** | Raised when the health synchronization receives a stop snapshot message without having started a snapshot at all. |
| **SubStreamMissingStop** | Raised when the health synchronization doesn't receive a stop snapshot after time out period of two times the `repeat_interval_s` established in the start snapshot message. In this case an automatic stop snapshot will be applied. |
| **SubStreamExpired** | Raised when the health synchronization stops receiving data on a particular substream for longer than the configured `expiry_interval_s`. In this case, the substream will be deleted. |
| **SubStreamLateData** | Raised when the health synchronization doesn't receive a complete snapshot timely based on the established `repeat_interval_s`. |
| **SubStreamTransformerError** | Raised when the health synchronization is unable to interpret the payload sent to the receiver. For example, "Missing required field 'name'" with payload `{"checkStateId":"checkStateId3","health":"deviating","message":"Unable to provision the device. ","topologyElementIdentifier":"server-3"}` and transformation `Default Transformation`. |
| **SubStreamMissingCheckpoint** | Raised when a Transactional increments substream previously observed a checkpoint, but the received message is missing the `previous_checkpoint` |
| **SubStreamInvalidCheckpoint** | Raised when a Transactional increments substream previously observed a checkpoint, but the received message has a `previous_checkpoint` that isn't equivalent to the last observed one. |
| **SubStreamOutdatedCheckpoint** | Raised when a Transactional increments substream previously observed a checkpoint, but the received message has a `checkpoint` that precedes the last observed one, meaning that its data that SUSE Observability already received. |
| **SubStreamUnknownCheckState** | Raised when deleting a Transactional increments check_state and the `check_state_id` isn't present on the substream.

## See also

* [Install the SUSE Observability CLI](../../../setup/cli/cli-sts.md)
