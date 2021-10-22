# Debug health synchronization

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

The [StackState CLI](../../setup/installation/cli-install.md) can be used to debug a health synchronization and fix issues that might prevent health data from being correctly ingested and displayed in StackState. This page describes the general troubleshooting steps to take when debugging a health synchronization, as well as the CLI commands used, and a description of the error messages returned.

## General troubleshooting steps

When debugging the health synchronization there are some common verification steps that can be made no matter what the specific issue is:

1. [Verify that the stream exists](debug-health-sync.md#list-streams).
2. If you are using sub streams, [verify that the sub stream exists](debug-health-sync.md#list-sub-streams). The response will also show the number of check states on the sub stream. This lets you know if the data is being ingested and processed.
3. Investigate further:
   * **Stream present** - [Check the stream status](debug-health-sync.md#show-stream-status), this will show the metrics latency of the stream and any [errors](debug-health-sync.md#error-messages).
   * **Streams / sub streams present, but there are no check states** - Confirm that the payload sent to the Receiver API adheres to the [health payload specification](send-health-data.md).
   * **No streams / sub streams are present** - Use the CLI command below to verify that health data sent to the Receiver API is arriving in StackState. 

     ```text
     sts topic show sts_health_sync
     ```

## Common issues

### Check state not visible on the component

There can be two reasons for a check state not to show on a component in StackState:

* The health check state has not been created. Follow the [general troubleshooting steps](debug-health-sync.md#general-troubleshooting-steps) to confirm that the stream / sub stream has been created and that data is arriving in StackState.
* The health check state was created, but its `topologyElementIdentifier` does not match any `identifiers` from the StackState topology. Use the CLI command [show sub stream status](debug-health-sync.md#show-sub-stream-status) to verify if there are any `Check states with identifier which has no matching topology element`.

### Check state slow to update in StackState

The main reason for this is that the latency of the health synchronization is higher than expected. Use the CLI command [show stream status](debug-health-sync.md#show-stream-status) to confirm the latency of the stream as well as the throughput of messages and specific check operations. It may be necessary to tweak the data sent to the health synchronization, or the frequency with which data is sent.

## Useful CLI commands

### List streams

Returns a list of all current synchronized health streams and the number of sub streams included in each.

```javascript
# List streams
sts health list-streams

stream urn                                            sub stream count
--------------------------------------------------  ------------------
urn:health:sourceId:streamId                                         1
```

### List sub streams

Returns a list of all sub streams for a given stream URN, together with the number of check states in each.

```javascript
# List sub streams
sts health list-sub-streams urn:health:sourceId:streamId 

sub stream id                     check state count
------------------------------  -------------------
subStreamId1                                     20
subStreamId2                                     17
```

### Show stream status

The stream status command returns the aggregated stream latency and throughput metrics. This is helpful when debugging why a health check takes a long time to land on the expected topology elements. It will help diagnose if the frequency of data sent to StackState should be adjusted. The output contains a section `Errors for non-existing sub streams:` as some errors are only relevant when a sub stream could not be created, for example `StreamMissingSubStream`. Sub stream errors can be any of the documented [error messages](debug-health-sync.md#error-messages).

```javascript
# Show a stream status
sts health show urn:health:sourceId:streamId

Aggregate metrics for the stream and all substreams:

metric                             value between now and 300 seconds ago    value between 300 and 600 seconds ago    value between 600 and 900 seconds ago
---------------------------------  ---------------------------------------  ---------------------------------------  ---------------------------------------
latency (Seconds)                  1.102                                    1.102                                    -
messages processed (per second)    0.256                                    0.16                                     -
check states created (per second)  0.10555555555555556                      0.10666666666666667                      -
check states updated (per second)  -                                        -                                        -
check states deleted (per second)  -                                        -                                        -

Errors for non-existing sub streams:

error message                                                                                   error occurrence count
----------------------------------------------------------------------------------------------  ------------------------
Sub stream `substream with id `subStreamId2`` not started when receiving snapshot stop                          6
```

### Show sub stream status

The sub stream status provides useful information to verify that check states sent to StackState from an external system could be bound and linked to existing topology elements. This information is helpful to debug why a specific check is not visible on the expected topology element.

In the example below, `checkStateId2` is listed under `Check states with identifier which has no matching topology element`. This means that it was not possible to match the check state to a topology element with the identifier `server-2`.

```javascript
# Show a sub stream status.
sts health show urn:health:sourceId:streamId -s "subStreamId3" -t
# Is we configured our stream to not use explicit substreams then a default 
# sub stream can be reached by omitting the optional substreamId parameter as in: 
#sts health show urn:health:sourceId:streamId -t

Check states with identifier matching exactly 1 topology element: 32

Check states with identifier which has no matching topology element:

check state id    topology element identifier
----------------  -----------------------------
checkStateId2     server-2

Check states with identifier which has multiple matching topology elements:

check state id    topology element identifier    number of matched topology elements
----------------  -----------------------------  -------------------------------------
```

### Delete a health stream

The delete stream functionality is helpful while setting up a health synchronization in StackState. It allows you to experiment, delete the data and start over again clean. You can also delete a stream and drop it's data when you are sure that you do not want to keep using it.

```javascript
# Delete a health synchronization stream
sts health delete urn:health:sourceId:streamId
```

## Error messages

{% hint style="info" %}
Errors will be closed once the described issue has been remediated.

For example a `SubStreamStopWithoutStart` will be closed once the health synchronization observes a start snapshot message followed by a stop snapshot message.
{% endhint %}

| Error | Description |
| :--- | :--- |
| **StreamMissingSubStream** | Raised when the health synchronization receives messages with a previous start snapshot in place. |
| **SubStreamRepeatIntervalTooHigh** | Raised when the health synchronization receives a `repeat_interval_s` greater than the configured max of 30 minutes. |
| **SubStreamStartWithoutStop** | Raised when the health synchronization receives a second message to open a snapshot when a previous snapshot was still open. |
| **SubStreamCheckStateOutsideSnapshot** | Raised when the health synchronization receives external check states without previously opening a snapshot. |
| **SubStreamStopWithoutStart** | Raised when the health synchronization receives a stop snapshot message without having started a snapshot at all. |
| **SubStreamMissingStop** | Raised when the health synchronization does not receive a stop snapshot after time out period of two times the `repeat_interval_s` established in the start snapshot message. In this case an automatic stop snapshot will be applied. |
| **SubStreamExpired** | Raised when the health synchronization stops receiving data on a particular sub stream for longer than the configured `expiry_interval_s`. In this case, the sub stream will be deleted. |
| **SubStreamLateData** | Raised when the health synchronization does not receive a complete snapshot timely based on the established `repeat_interval_s`. |
| **SubStreamTransformerError** | Raised when the health synchronization is unable to interpret the payload sent to the receiver. For example, "Missing required field 'name'" with payload `{"checkStateId":"checkStateId3","health":"deviating","message":"Unable to provision the device. ","topologyElementIdentifier":"server-3"}` and transformation `Default Transformation`. |

## See also

* [Install the StackState CLI](../../setup/installation/cli-install.md)
* [StackState CLI reference](../../develop/reference/cli_reference.md)

