---
title: Topology sources
kind: Documentation
---

# Topology sources

{% hint style="warning" %}
**This page describes StackState version 4.1.** 

The StackState 4.1 version range is End of Life \(EOL\) and no longer supported. We encourage customers still running the 4.1 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

Topology Sources are configured in Sts Sources under Topology Sources in the Settings page. These sources are used to get data from the Kafka bus, which receives the data from the StackState topology API.

The data source creation screen looks like this:

![Add a data source screen](../../.gitbook/assets/create-data-source-screen.png)

The screen contains the following fields:

* `Name`: The name of the data source.
* `Description`: A description of the data source.
* `Use StackState's default Kafka`: Use the default Kafka bus on the StackState server or a separate Kafka instance.
* `Integration Type`: Select the integration type from the dropdown. This list is populated with the type passed in the `instance` / `type` field in the source JSON data.
* `Kafka Topic`: Select a Kafka topic to retrieve data from. This list is populated based on the type and URL passed in the `instance` field in the source JSON data.

The following advanced settings are also available:

* `Maximum batch size`: Specifies the maximum number of components from a JSON file that are processed in a single batch. Used for rate limiting.
* `Maximum # of batches/second`: Specifies the maximum number of batches processed per second. Used for rate limiting.
* `Expire elements`: Set topology to elements to _expired_ if they do not appear in this data source for a configured amount of time.
* `Cleanup expired elements`: Remove _expired_ topology elements from StackState if they have been expired for a configured amount of time.

_NOTE_: if the topology data is sent in _snapshot_ mode \(see the JSON format description\), expiry and cleanup of elements are not necessary, since each snapshot represents a complete landscape instance and elements missing from the snapshot are automatically deleted.

The screen contains the following buttons:

* `Test Connection`: Verify that the target Kafka server is reachable.
* `Refresh`: Refresh the lists of integration types and topics.
* `Create`: Create the data source.
* `Cancel`: Cancel creation of the data source.

