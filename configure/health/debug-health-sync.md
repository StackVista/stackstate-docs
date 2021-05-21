# Debug health synchronization

## Overview
StackState health synchronization provides a series of error messages via the [StackState CLI](/setup/installation/cli-install.md)] in order to debug and fix issues that might be preventing health data to be correctly ingested and displayed on StackState.

## General troubleshooting steps
When debugging the health synchronization there are some common verification steps that can be made no matter what the specific issue is:
* Verify that the expected Stream exists using the [list health streams](debug-health-sync.md#list-streams) CLI command
* Verify that the expected SubStream exists (in case you are using sub streams) using the [list health sub streams](debug-health-sync.md#list-streams) CLI call. The response shows as well the number of check states on the sub stream which alreadt gives information about if the data is being inhested and processed.
* In case that no streams/sub streams are present we can always verify is the data we are sending to the Receiver Api is ending up in StackState. The [StackState CLI](../../setup/installation/cli-install.md) contains a way to see what data ends up on the health topic.
* In case we do have streams/sub streams created but no check states we can double check that the payload we are sending to the Receiver Api adheres to the [specification](/configure/health/send-health-data.md).
* In case the stream is created we can query as well the status of it using the [show stream](debug-health-sync.md#show-streams) CLI command which could show us both metrics latency related to your stream as well as potential [errors](debug-health-sync.md#error-messages) ocurring.

## Why is my check state not visible on the component?
There can be two reasons for this kind of issue:
* The check state is not even create. This can be debugged using the [general troubleshooting steps](debug-health-sync.md#general-troubleshooting-steps)
* The check is created but its `topologyElementIdentifier` does not match any `identifiers` from topology. This can be verified using the [show sub stream](debug-health-sync.md#show-sub-stream) CLI call which will report any `Check states with identifier which has no matching topology element`.

## Why does my check state takes a long time to change state on StackState?
The main reason for this is that the latency of the health synchronization is higher than we expect. This can be verified using the [show stream](debug-health-sync.md#show-streams) CLI command which will show us the latency for the stream as well as the throughput of messages and specific check operations. This will help us debug and tweak the data and the frequency of the data that we are sending to the health synchronization.

### Useful CLI commands to debug Health Synchronization
#### List Streams
{% tabs %}
{% tab title="List Streams overview" %}
```javascript
# List streams
sts health list-streams

stream urn                                            sub stream count
--------------------------------------------------  ------------------
urn:health:sourceId:streamId                                         1
```
{% endtab %}
{% endtabs %}

#### List Sub Streams
{% tabs %}
{% tab title="List Sub Streams overview" %}
```javascript
# List sub streams
sts health list-sub-streams urn:health:sourceId:streamId 

sub stream id                     check state count
------------------------------  -------------------
subStreamId1                                     20
subStreamId2                                     17
```
{% endtab %}
{% endtabs %}

#### Show Stream
{% tabs %}
{% tab title="Show stream status" %}
```javascript
# Show a stream status
sts health show urn:health:sourceId:streamId

Synchronized check state count: 1

Synchronization errors:

code                       level    message                                                        occurrence count
-------------------------  -------  -----------------------------------------------------------  ------------------
SubStreamStopWithoutStart  ERROR    Encountered a stop snapshot without seeing a start snapshot                   1


Aggregate metrics for the stream and all substreams:

metric                             value between now and 300 seconds ago    value between 300 and 600 seconds ago    value between 600 and 900 seconds ago
---------------------------------  ---------------------------------------  ---------------------------------------  ---------------------------------------
latency (Seconds)                  1.102                                    1.102                                    -
messages processed (per second)    0.256                                    0.16                                     -
check states created (per second)  0.10555555555555556                      0.10666666666666667                      -
check states updated (per second)  -                                        -                                        -
check states deleted (per second)  -                                        -                                        -

Errors for non-existing sub streams:

code                       level    message                                                                                  occurrence count
-------------------------  -------  ---------------------------------------------------------------------------------------  ------------------
StreamMissingSubStream     ERROR    Sub stream `substream with id `subStreamId2`` not started when receiving snapshot stop                    6
```
{% endtab %}
{% endtabs %}


{% hint style="info" %}
The stream status provides aggregated stream latency and throughput metrics to help you diagnose if the frequency of the data being sent to StackState might need to be adjusted. Those metrics are helpful when we are debugging why our health checks take a long time to land on the expected topology elements.
The output contains an `Errors for non-existing sub streams:` section as some errors are only relevant when the sub stream could not be created such as `StreamMissingSubStream`.
The sub stream errors can contain any of the documented [Error messages](debug-health-sync.md#error-messages)
{% endhint %}

{% tabs %}
{% tab title="List sub streams overview" %}
```javascript
# List sub streams for a given stream urn
sts health list-sub-streams urn:health:sourceId:streamId 

sub stream id        check state count
-----------------  -------------------
subStreamId3                        32
```
{% endtab %}
{% endtabs %}

#### Show Sub Stream
{% tabs %}
{% tab title="Show substream status" %}
```javascript
# Show a substream status.
sts health show urn:health:sourceId:streamId -s "subStreamId3" -t
# If we configured our stream to not use explicit substreams then a default substream can be reached by omitting the optional substreamId parameter as in: 
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
{% endtab %}
{% endtabs %}

{% hint style="info" %}
The substream status provides useful information to verify that the check states sent from the external system into StackState could be bound and linked to existing topology elements. In the example we show a `Check states with identifier which has no matching topology element` a case where a check state `checkStateId2` could not be related to a topology element identified as `server-2`. Helpful when we are debugging why a specific check is not visible in the expected topology element.
{% endhint %}

#### Delete Streams
{% tabs %}
{% tab title="Delete a health synchronization stream" %}
```javascript
# Delete a health synchronization stream
sts health delete urn:health:sourceId:streamId 

```
{% endtab %}
{% endtabs %}
{% hint style="info" %}
The delete stream functionality is helpful while working out the integration with StackState as we can do some experiments, delete the data and start all over again or when we are sure that we don't want to keep using a stream and we want to drop it's data.
{% endhint %}

### Error messages
* **StreamMissingSubStream** - Raised when the health synchronization receives messages with a previous start snapshot in place.
* **SubStreamRepeatIntervalTooHigh** - Raised when the health synchronization receives a `repeat_interval_s` greater than the configured max of 30 minutes.
* **SubStreamStartWithoutStop** - Raised when the health synchronization receives a second message to open a snapshot when a previous snapshot was still open.
* **SubStreamCheckStateOutsideSnapshot** - Raised when the health synchronization receives external check states without previously opening a snapshot.
* **SubStreamStopWithoutStart** - Raised when the health synchronization receives a stop snapshot message without having started a snapshot at all.
* **SubStreamMissingStop** - Raised when the health synchronization does not receive a stop snapshot after time out period of two times the `repeat_interval_s` established in the start snapshot message. In this case an automatic stop snapshot will be applied.
* **SubStreamExpired** - Raised when the health synchronization stops receiving data on a particular sub stream for longer than the configured `expiry_interval_s`. In this case the sub stream will be deleted.

{% hint style="info" %}
All the previously described errors will be closed once the issue is remediated, e.g. a `SubStreamStopWithoutStart` will be closed once the health synchronization observes a new stop snapshot message that properly closes a previously start snapshot.
{% endhint %}


## See also

* [Install the StackState CLI](/setup/installation/cli-install.md)
* [StackState CLI reference](/develop/reference/cli_reference.md)